-- Échecs à trois dimensions : classement mondial
-- À coller dans Supabase > SQL Editor > New query, puis « Run ».

create table if not exists public.players (
  id uuid primary key references auth.users on delete cascade,
  name text not null default 'Joueur' check (char_length(name) between 1 and 16),
  elo int not null default 1200,
  games int not null default 0,
  wins int not null default 0,
  losses int not null default 0,
  draws int not null default 0,
  best int not null default 1200,
  last_game timestamptz,
  created_at timestamptz not null default now()
);
create index if not exists players_elo on public.players (elo desc);

-- Lecture publique du classement ; aucune écriture directe :
-- tout passe par les deux fonctions ci-dessous, qui vérifient les données.
alter table public.players enable row level security;
drop policy if exists "lecture publique" on public.players;
create policy "lecture publique" on public.players for select using (true);

-- Changer son pseudo
create or replace function public.set_name(n text) returns public.players
language plpgsql security definer set search_path = public as $$
declare p public.players;
begin
  if auth.uid() is null then raise exception 'non connecté'; end if;
  n := btrim(regexp_replace(coalesce(n, ''), '\s+', ' ', 'g'));
  if char_length(n) < 1 or char_length(n) > 16 then raise exception 'pseudo invalide'; end if;
  insert into public.players (id, name) values (auth.uid(), n)
    on conflict (id) do update set name = excluded.name
    returning * into p;
  return p;
end $$;

-- Enregistrer une partie contre le bot : l'ELO est calculé ici, pas dans le navigateur.
-- res : 'w' gagné, 'l' perdu, 'd' nulle ; lvl : 1 Facile, 2 Moyen, 3 Fort ; moves : nombre de coups joués.
create or replace function public.report_game(res text, lvl int, moves int) returns public.players
language plpgsql security definer set search_path = public as $$
declare p public.players; rb int; ew float8; s float8; d int;
begin
  if auth.uid() is null then raise exception 'non connecté'; end if;
  if res not in ('w', 'l', 'd') or lvl not in (1, 2, 3) then raise exception 'données invalides'; end if;
  if res = 'w' and coalesce(moves, 0) < 3 then raise exception 'partie trop courte'; end if;
  insert into public.players (id) values (auth.uid()) on conflict (id) do nothing;
  select * into p from public.players where id = auth.uid() for update;
  if p.last_game is not null and p.last_game > now() - interval '15 seconds' then raise exception 'trop rapide'; end if;
  rb := case lvl when 1 then 800 when 2 then 1200 else 1500 end;
  ew := 1 / (1 + power(10, (rb - p.elo) / 400.0));
  s := case res when 'w' then 1 when 'd' then 0.5 else 0 end;
  d := round(32 * (s - ew));
  update public.players set
    elo = greatest(100, elo + d),
    best = greatest(best, elo + d),
    games = games + 1,
    wins = wins + (res = 'w')::int,
    losses = losses + (res = 'l')::int,
    draws = draws + (res = 'd')::int,
    last_game = now()
  where id = auth.uid()
  returning * into p;
  return p;
end $$;

revoke all on function public.set_name(text) from public, anon;
revoke all on function public.report_game(text, int, int) from public, anon;
grant execute on function public.set_name(text) to authenticated;
grant execute on function public.report_game(text, int, int) to authenticated;
