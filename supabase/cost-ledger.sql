-- Independent spending ledger. Run once in the Supabase SQL editor.
create table if not exists public.cost_ledger (
  user_id uuid not null references auth.users(id) on delete cascade,
  id text not null,
  timestamp bigint not null,
  cost double precision not null check (cost >= 0),
  estimated boolean not null default true,
  primary key (user_id, id)
);
alter table public.cost_ledger enable row level security;
drop policy if exists cost_ledger_owner on public.cost_ledger;
create policy cost_ledger_owner on public.cost_ledger for all to authenticated
using (auth.uid() = user_id) with check (auth.uid() = user_id);
grant select, insert, update on public.cost_ledger to authenticated;
