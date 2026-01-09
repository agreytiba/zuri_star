-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Create Profiles Table
create table public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  full_name text,
  email text,
  role text check (role in ('customer', 'salon_owner')),
  avatar_url text,
  created_at timestamptz default now()
);

-- RLS
alter table public.profiles enable row level security;
create policy "Public profiles are viewable by everyone" on public.profiles for select using (true);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);

-- Function to handle new user signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, email, role)
  values (
    new.id, 
    new.raw_user_meta_data->>'full_name', 
    new.email,
    new.raw_user_meta_data->>'role'
  );
  return new;
end;
$$ language plpgsql security definer;

-- Trigger
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ============================================
-- SALON OWNER MODULE TABLES
-- ============================================

-- Salons Table (for salon owners to manage their salons)
create table public.salons (
  id uuid default uuid_generate_v4() primary key,
  owner_id uuid references public.profiles(id) on delete cascade not null,
  name text not null,
  description text,
  address text,
  latitude double precision,
  longitude double precision,
  phone_number text,
  email text,
  rating double precision default 0,
  review_count integer default 0,
  is_verified boolean default false,
  is_mobile_service boolean default false,
  is_in_salon boolean default true,
  gender_specific text check (gender_specific in ('male', 'female', 'unisex')) default 'unisex',
  images text[], -- array of image URLs
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Services Table (services offered by salons)
create table public.services (
  id uuid default uuid_generate_v4() primary key,
  owner_id uuid references public.profiles(id) on delete cascade not null,
  salon_id uuid references public.salons(id) on delete cascade,
  name text not null,
  description text,
  price double precision not null,
  duration_minutes integer not null,
  is_enabled boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Staff Table (staff members working for salon owners)
create table public.staff (
  id uuid default uuid_generate_v4() primary key,
  owner_id uuid references public.profiles(id) on delete cascade not null,
  salon_id uuid references public.salons(id) on delete cascade,
  name text not null,
  avatar_url text,
  skills text[], -- array of service names/skills
  commission_rate double precision default 0, -- percentage (0-100)
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Bookings Table
create table public.bookings (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  salon_id uuid references public.salons(id) on delete cascade,
  owner_id uuid references public.profiles(id) on delete cascade not null, -- denormalized for easy queries
  salon_name text not null,
  service_type text not null,
  service_description text,
  booking_date timestamptz not null,
  time_slot text not null,
  price double precision not null,
  status text check (status in ('pending', 'confirmed', 'completed', 'cancelled', 'rescheduled')) default 'pending',
  is_instant_booking boolean default false,
  notes text,
  calendar_event_id text,
  reminder_set boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Reviews Table
create table public.reviews (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  salon_id uuid references public.salons(id) on delete cascade,
  owner_id uuid references public.profiles(id) on delete cascade not null, -- denormalized for easy queries
  booking_id uuid references public.bookings(id) on delete set null,
  rating double precision not null check (rating >= 0 and rating <= 5),
  comment text,
  images text[], -- array of image URLs
  helpful_count integer default 0,
  is_verified_booking boolean default false,
  created_at timestamptz default now()
);

-- Earnings Table (for tracking revenue)
create table public.earnings (
  id uuid default uuid_generate_v4() primary key,
  owner_id uuid references public.profiles(id) on delete cascade not null,
  booking_id uuid references public.bookings(id) on delete set null,
  amount double precision not null,
  date date not null,
  description text,
  created_at timestamptz default now()
);

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Salons RLS
alter table public.salons enable row level security;
create policy "Salons are viewable by everyone" on public.salons for select using (true);
create policy "Owners can manage their own salons" on public.salons for all using (auth.uid() = owner_id);

-- Services RLS
alter table public.services enable row level security;
create policy "Services are viewable by everyone" on public.services for select using (true);
create policy "Owners can manage their own services" on public.services for all using (auth.uid() = owner_id);

-- Staff RLS
alter table public.staff enable row level security;
create policy "Staff are viewable by everyone" on public.staff for select using (true);
create policy "Owners can manage their own staff" on public.staff for all using (auth.uid() = owner_id);

-- Bookings RLS
alter table public.bookings enable row level security;
create policy "Users can view their own bookings" on public.bookings for select using (auth.uid() = user_id);
create policy "Owners can view their salon bookings" on public.bookings for select using (auth.uid() = owner_id);
create policy "Users can create bookings" on public.bookings for insert with check (auth.uid() = user_id);
create policy "Owners can update their salon bookings" on public.bookings for update using (auth.uid() = owner_id);
create policy "Users can cancel their own bookings" on public.bookings for update using (auth.uid() = user_id);

-- Reviews RLS
alter table public.reviews enable row level security;
create policy "Reviews are viewable by everyone" on public.reviews for select using (true);
create policy "Users can create reviews for their bookings" on public.reviews for insert with check (auth.uid() = user_id);
create policy "Users can update their own reviews" on public.reviews for update using (auth.uid() = user_id);

-- Earnings RLS
alter table public.earnings enable row level security;
create policy "Owners can view their own earnings" on public.earnings for select using (auth.uid() = owner_id);
create policy "System can create earnings" on public.earnings for insert with check (auth.uid() = owner_id);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

create index idx_salons_owner_id on public.salons(owner_id);
create index idx_services_owner_id on public.services(owner_id);
create index idx_services_salon_id on public.services(salon_id);
create index idx_staff_owner_id on public.staff(owner_id);
create index idx_staff_salon_id on public.staff(salon_id);
create index idx_bookings_user_id on public.bookings(user_id);
create index idx_bookings_owner_id on public.bookings(owner_id);
create index idx_bookings_salon_id on public.bookings(salon_id);
create index idx_bookings_booking_date on public.bookings(booking_date);
create index idx_reviews_owner_id on public.reviews(owner_id);
create index idx_reviews_salon_id on public.reviews(salon_id);
create index idx_earnings_owner_id on public.earnings(owner_id);
create index idx_earnings_date on public.earnings(date);

-- ============================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================

create or replace function public.update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger update_salons_updated_at before update on public.salons
  for each row execute procedure public.update_updated_at_column();

create trigger update_services_updated_at before update on public.services
  for each row execute procedure public.update_updated_at_column();

create trigger update_staff_updated_at before update on public.staff
  for each row execute procedure public.update_updated_at_column();

create trigger update_bookings_updated_at before update on public.bookings
  for each row execute procedure public.update_updated_at_column();

-- ============================================
-- FUNCTION TO AUTO-SET OWNER_ID ON BOOKINGS
-- ============================================

create or replace function public.set_booking_owner_id()
returns trigger as $$
begin
  -- Auto-set owner_id from salon when booking is created
  if new.owner_id is null and new.salon_id is not null then
    select owner_id into new.owner_id from public.salons where id = new.salon_id;
  end if;
  return new;
end;
$$ language plpgsql;

create trigger set_booking_owner_id_trigger before insert on public.bookings
  for each row execute procedure public.set_booking_owner_id();

-- ============================================
-- FUNCTION TO AUTO-SET OWNER_ID ON REVIEWS
-- ============================================

create or replace function public.set_review_owner_id()
returns trigger as $$
begin
  -- Auto-set owner_id from salon when review is created
  if new.owner_id is null and new.salon_id is not null then
    select owner_id into new.owner_id from public.salons where id = new.salon_id;
  end if;
  return new;
end;
$$ language plpgsql;

create trigger set_review_owner_id_trigger before insert on public.reviews
  for each row execute procedure public.set_review_owner_id();
