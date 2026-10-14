create table if not exists public.rsvp (
  id uuid primary key default gen_random_uuid(),
  nama text not null check (char_length(trim(nama)) between 1 and 50),
  ucapan text not null check (char_length(trim(ucapan)) between 1 and 500),
  kehadiran text not null check (kehadiran in ('Hadir', 'Tidak Hadir')),
  tanggal timestamptz not null default now()
);

alter table public.rsvp enable row level security;

grant select, insert on table public.rsvp to anon;

drop policy if exists "Publik dapat melihat RSVP" on public.rsvp;
create policy "Publik dapat melihat RSVP"
  on public.rsvp for select to anon using (true);

drop policy if exists "Publik dapat mengirim RSVP" on public.rsvp;
create policy "Publik dapat mengirim RSVP"
  on public.rsvp for insert to anon
  with check (
    char_length(trim(nama)) between 1 and 50
    and char_length(trim(ucapan)) between 1 and 500
    and kehadiran in ('Hadir', 'Tidak Hadir')
  );