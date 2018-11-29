DROP table if exists public."określenie" CASCADE;
DROP table if exists public."język" CASCADE;
DROP table if exists public."tłumaczenie" CASCADE;


create table if not exists "język"
(
  id        serial    PRIMARY KEY  not null,
  nazwa     varchar(255) not null,
  kod_iso   varchar(2) not null
);


create table if not exists "określenie"
(
  id        serial    PRIMARY KEY  not null,
  nazwa     varchar(255) not null,
  definicja text,
  język int NOT NULL references język(id)
);


create table if not exists "tłumaczenie"
(
    id serial PRIMARY KEY NOT NULL,
    źródło int NOT NULL references określenie(id),
    cel int NOT NULL references określenie(id),
    unique(źródło, cel)
);


insert into język(id, nazwa, kod_iso) values (1, 'Polski', 'PL');
insert into język(id, nazwa, kod_iso) values (2, 'Francuski', 'FR');
insert into język(id, nazwa, kod_iso) values (3, 'Angielski', 'EN');

insert into określenie(nazwa, definicja, język) values('język', 'Język, jakim mówimy', 1);
insert into określenie(nazwa, definicja, język) values('langue', 'La langue que nous parlons', 2);
insert into określenie(nazwa, definicja, język) values('language', 'Language we speak', 3);

insert into tłumaczenie(źródło, cel) values (1, 2);
insert into tłumaczenie(źródło, cel) values (1, 3);
insert into tłumaczenie(źródło, cel) values (2, 3);
insert into tłumaczenie(źródło, cel) values (2, 1);
insert into tłumaczenie(źródło, cel) values (3, 1);
insert into tłumaczenie(źródło, cel) values (3, 2);


DROP FUNCTION tłumacz(character varying,character varying);
CREATE or REPLACE FUNCTION tłumacz(term varchar, lang  varchar)
 RETURNS TABLE (
  pojęcie varchar,
  język_źródłowy_nazwa varchar,
  tłumaczenie varchar,
  tłumaczenie_definicja text,
  język_docelowy_nazwa varchar )
  AS $func$
BEGIN
RETURN QUERY
  select o.nazwa as pojęcie,
         jz.nazwa as język_źródłowy_nazwa,
         ot.nazwa as tłumaczenie,
         ot.definicja as definicja,
         jd.nazwa as język_docelowy_nazwa
    FROM
      język jz,
      język jd,
      określenie o,
      określenie ot,
      tłumaczenie t
    WHERE
      o.nazwa=term
      and
      jd.kod_iso=lang
      and
      t.cel = jd.id
      and
      t.źródło = o.język
      and jz.id = o.język
      and ot.język = jd.id
;

END ; $func$
LANGUAGE PLPGSQL;
