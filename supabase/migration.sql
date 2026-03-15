create table transactions (

id uuid primary key default uuid_generate_v4(),

user_id uuid references auth.users(id),

type text,
category text,
amount numeric,

note text,

created_at timestamp default now()

);

alter table transactions enable row level security;
create policy "Users can access their own data"
on transactions
for all
using (auth.uid() = user_id);


create table budgets (

id uuid primary key default uuid_generate_v4(),

user_id uuid references auth.users(id),

category text,

limit_amount numeric,

month text

);

create table investments (

id uuid primary key default uuid_generate_v4(),

user_id uuid references auth.users(id),

stock_symbol text,

quantity numeric,

buy_price numeric

);