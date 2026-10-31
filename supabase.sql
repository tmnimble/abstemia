-- Ejecutar en Supabase > SQL Editor.
create table if not exists public.survey_responses (
 id uuid primary key default gen_random_uuid(),
 created_at timestamptz not null default now(),
 answers jsonb not null check (jsonb_typeof(answers) = 'object' and pg_column_size(answers) < 30000)
);
create table if not exists public.admin_users (
 user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.survey_responses enable row level security;
alter table public.admin_users enable row level security;
revoke all on public.survey_responses from anon, authenticated;
revoke all on public.admin_users from anon, authenticated;
grant insert on public.survey_responses to anon, authenticated;
grant select on public.survey_responses to authenticated;
-- No otorgar acceso público a admin_users.
drop policy if exists "Public can submit survey" on public.survey_responses;
create policy "Public can submit survey" on public.survey_responses for insert to anon, authenticated with check (true);
drop policy if exists "Only authorized admin can read responses" on public.survey_responses;
create policy "Only authorized admin can read responses" on public.survey_responses for select to authenticated using (
 exists (select 1 from public.admin_users a where a.user_id = (select auth.uid()))
);
-- Importante: crear primero el usuario en Authentication > Users.
-- Después ejecutar como propietario en SQL Editor:
-- insert into public.admin_users(user_id)
-- select id from auth.users where email = 'correo-del-dueno@ejemplo.com'
-- on conflict do nothing;
-- IMPORTANTE: deshabilitar registros públicos en Authentication > Providers > Email
-- para que solo usuarios creados por el administrador puedan iniciar sesión.
