/*
docker run --name postgresql -e POSTGRES_USER=yoel -e POSTGRES_PASSWORD=newdata -p 5432:5432 -d postgres
docker exec -it postgresql psql -U yoel
CREATE DATABASE nombre_de_la_base_de_datos;


CREATE ROLE sn_crud_user LOGIN PASSWORD 'cascadesheet';
CREATE DATABASE sn_crud OWNER sn_crud_user;

*/


CREATE SCHEMA app;


CREATE TABLE app.actions (
  id serial primary key,
  title varchar(64) NOT NULL,
  description varchar(64) DEFAULT '',
  icon varchar(64) DEFAULT '',
  event_name varchar(64) NOT NULL,
  event_name_prefix varchar(64) DEFAULT NULL,
  parent_id int default NULL,
  sort_order int default NULL,
  position varchar(12) DEFAULT 'TABLE' CHECK (position IN ('TABLE', 'TOOLBAR', 'FILTER', 'FOOTER')),
  class_names varchar(24) NOT NULL DEFAULT '',
  type varchar(24) DEFAULT 'button',
  keyboard_key varchar(12) DEFAULT '',
  
  state bool default true,
  updated_at timestamp(6) DEFAULT NULL,
  created_at timestamp(6) DEFAULT NULL,
  created_user varchar(64) DEFAULT '',
  updated_user varchar(64) DEFAULT ''
);

CREATE TABLE app.menus (
  id serial primary key,
  title varchar(64) NOT NULL,
  description varchar(64) DEFAULT '',
  icon varchar(64) DEFAULT '',
  url_path varchar(128) DEFAULT '',
  parent_id int DEFAULT null,
  sort_order int DEFAULT 1,
  
  state bool default true,
  updated_at timestamp(6) DEFAULT NULL,
  created_at timestamp(6) DEFAULT NULL,
  created_user varchar(64) DEFAULT '',
  updated_user varchar(64) DEFAULT ''
);



CREATE TABLE app.screens (
  id serial primary key,
  name varchar(128) NOT NULL,
  description varchar(64) DEFAULT '',
  type varchar(12) DEFAULT 'TABLE' CHECK (type IN ('TABLE', 'LIST', 'FORM', 'CUSTOM')),
  is_primary bool default false,

  menu_id int DEFAULT null REFERENCES app.menus(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  url_path varchar(128) DEFAULT '',
  help_url varchar(255) DEFAULT '',

  state bool default true,
  updated_at timestamp(6) DEFAULT NULL,
  created_at timestamp(6) DEFAULT NULL,
  created_user varchar(64) DEFAULT '',
  updated_user varchar(64) DEFAULT ''
);

CREATE TABLE app.screen_actions (
  id serial primary key,
  action_id int NOT null REFERENCES app.actions(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  screen_id int NOT null REFERENCES app.screens(id) ON DELETE RESTRICT ON UPDATE restrict,
  
  state bool default true,
  updated_at timestamp(6) DEFAULT NULL,
  created_at timestamp(6) DEFAULT NULL,
  created_user varchar(64) DEFAULT '',
  updated_user varchar(64) DEFAULT ''
);

CREATE TABLE app.user_roles (
  id serial primary key,
  description varchar(64) NOT NULL,
  
  state bool default true,
  updated_at timestamp(6) DEFAULT NULL,
  created_at timestamp(6) DEFAULT NULL,
  created_user varchar(64) DEFAULT '',
  updated_user varchar(64) DEFAULT ''
);

CREATE TABLE app.users (
  id serial primary key,
  user_name varchar(64) NOT NULL,
  password varchar(64) NOT NULL,
  full_name varchar(255) NOT NULL,
  last_name varchar(255) default '',
  gender varchar(1) DEFAULT '2' CHECK (gender IN ('0', '1', '2')),
  avatar varchar(64) DEFAULT '',
  email varchar(64) DEFAULT '',
  identity_document_number varchar(25) DEFAULT '',
  phone varchar(32) DEFAULT '',
  is_verified bool DEFAULT false,
  date_verified timestamp(6) DEFAULT NULL,
  -- identity_document_id int(11) NOT NULL,
  user_role_id int NOT null REFERENCES app.user_roles(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  
  state bool default true,
  updated_at timestamp(6) DEFAULT NULL,
  created_at timestamp(6) DEFAULT NULL,
  created_user varchar(64) DEFAULT '',
  updated_user varchar(64) DEFAULT ''
);

CREATE TABLE app.screen_action_roles (
  user_role_id int NOT null REFERENCES app.user_roles(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  screen_action_id int NOT null REFERENCES app.screen_actions(id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE app.screen_entities (
  id serial primary key,
  name varchar(128) NOT NULL,
  description varchar(128) default '',
  schema_name varchar(128) NOT NULL,
  table_name varchar(128) NOT NULL,
  table_view varchar(128) default '',
  parent_id INT DEFAULT NULL,
  multiple bool DEFAULT true,
  
  sp_pre_process varchar(128) default '',
  sp_pos_process varchar(128) default '',
  
  screen_id INT default null REFERENCES app.screens(id) ON DELETE RESTRICT ON UPDATE RESTRICT,

  state bool default true,
  updated_at timestamp(6) DEFAULT NULL,
  created_at timestamp(6) DEFAULT NULL,
  created_user varchar(64) DEFAULT '',
  updated_user varchar(64) DEFAULT ''
);

CREATE TABLE app.screen_entity_groups (
  id serial primary key,
  name varchar(128) NOT NULL,
  description varchar(128) NOT NULL,
  
  screen_entity_id int NOT null REFERENCES app.screen_entities(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  
  state bool default true,
  updated_at timestamp(6) DEFAULT NULL,
  created_at timestamp(6) DEFAULT NULL,
  created_user varchar(64) DEFAULT '',
  updated_user varchar(64) DEFAULT ''
);

CREATE TABLE app.screen_entity_fields (
  id serial primary key,
  field_name varchar(128) NOT NULL,
  field_title varchar(128) DEFAULT '',
  field_description varchar(128) DEFAULT '',
  field_placeholder varchar(128) DEFAULT '',
  data_type varchar(128) NOT NULL,
  component_name varchar(128) NOT NULL,
  is_nullable boolean NOT NULL,
  character_maximum_length int default null,
  filterable boolean DEFAULT true,
  sortable boolean DEFAULT true,
  visible boolean DEFAULT true,
  col_index int DEFAULT null,
  row_index int DEFAULT null,
  col_span int default null,
  row_span int default null,
  col_width numeric(6,2) default 0.00,
  
  sp_load varchar(128) default '',
  sp_validate varchar(128) default '',
  sp_pre_process varchar(128) default '',
  sp_pos_process varchar(128) default '',

  screen_entity_id int NOT null REFERENCES app.screen_entities(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  screen_entity_group_id int default null REFERENCES app.screen_entity_groups(id) ON DELETE RESTRICT ON UPDATE RESTRICT,

  state bool default true,
  updated_at timestamp(6) DEFAULT NULL,
  created_at timestamp(6) DEFAULT NULL,
  created_user varchar(64) DEFAULT '',
  updated_user varchar(64) DEFAULT ''
);


insert into app.user_roles (description) values ('APP');
insert into app.users (user_name, password, full_name, last_name, user_role_id)
	values ('app','app','app','app',1),
			('lima','lima','lima','lima',1),
			('trujillo','trujillo','trujillo','trujillo',1),
			('tumbes','tumbes','tumbes','tumbes',1),
			('tacna','tacna','tacna','tacna',1),
			('cusco','cusco','cusco','cusco',1),
			('puno','puno','puno','puno',1),
			('moquegua','moquegua','moquegua','moquegua',1);

insert into app.menus (title, description, icon, url_path, parent_id, sort_order)
	values ('Manteminiento','Manteminiento','','maintenance',null,2),
			('Usuario','Usuario','','maintenance/user',1,1),
			('Roles','Roles','','maintenance/userRole',1,2);

insert into app.screens (name, description, type, menu_id, url_path, help_url, is_primary)
	values ('Roles', 'Roles formulario', 'FORM',3,'maintenance/userRole/form','',false),
			('Roles', 'Roles tabla', 'TABLE',3,'maintenance/userRole','',true),
			('Usuario', 'Usuario formulario', 'FORM',2,'maintenance/user/form','',false),
			('Usuario', 'Usuario tabla', 'TABLE',2,'maintenance/user','',true);
		
insert into app.screen_entities (name, description, schema_name, table_name, screen_id, multiple)
	values ('Roles', 'Roles formulario', 'app','user_roles',1,false),
			('Roles', 'Roles tabla', 'app','user_roles',2,true),
			('Usuario', 'Usuario formulario', 'app','users',3,false),
			('Usuario', 'Usuario tabla', 'app','users',4,true);
		
insert into app.actions (title, description, icon, event_name, position)
values ('Refrescar','Refrescar','','refresh', 'TOOLBAR'),
		('Nuevo','Nuevo','','new','TOOLBAR'),
		('Aditar','Aditar','','edit','TABLE'),
		('Eliminar','Eliminar','','delete','TABLE'),
		('Guardar','Guardar','','submit','TOOLBAR'),
		('Listar','Listar','','list','TOOLBAR');
	
insert into app.screen_actions (action_id, screen_id)
	values (1,4), (2,4), (3,4), (4,4);



CREATE OR REPLACE PROCEDURE app.usp_build_base_entity_fields(
 	in _schema_name VARCHAR(64),	
    in _table_name VARCHAR(64),
    in _screen_entity_id int
)
LANGUAGE plpgsql
AS $$
begin
    -- I N S E R T
    insert into app.screen_entity_fields (
	  field_name,
	  field_title,
	  field_description,
	  field_placeholder,
	  data_type,
	  component_name,
	  is_nullable,
	  character_maximum_length,
	  filterable,
	  sortable,
	  visible,
	  col_index,
	  screen_entity_id
	)
    select
		isc.column_name,
		initcap(replace(isc.column_name, '_', ' ')),
		initcap(replace(isc.column_name, '_', ' ')),
		isc.column_name,
		isc.data_type,
		'input',
		case when is_nullable='YES' then true else false end,
		isc.character_maximum_length,
		true,
		true,
		case when isc.column_name in ('updated_at','created_at','created_user','updated_user') then false else true end,
		isc.ordinal_position,
		_screen_entity_id
	from information_schema.columns as isc
	left join (
		select sef.id, se.schema_name, se.table_name, sef.field_name from app.screen_entity_fields as sef
		inner join app.screen_entities as se on se.id = sef.screen_entity_id and se.id = _screen_entity_id
	) as dsef on dsef.field_name = isc.column_name and dsef.schema_name = isc.table_schema and dsef.table_name = isc.table_name
	where isc.table_schema = _schema_name and isc.table_name = _table_name and dsef.id is null;


	/*
	-- U P D A T E
	update dictionary.screen_entity_fields AS sef_update
	set data_type = col.data_type,
	    is_nullable = case when col.is_nullable='YES' then true else false end,
	    character_maximum_length = col.character_maximum_length,
	    col_index = col.ordinal_position
	from dictionary.screen_entity_fields AS sef
	inner join dictionary.screen_entities AS se ON se.id = sef.screen_entity_id AND se.schema_name = _schema_name AND se.table_name = _table_name and se.screen_id = _screen_id
	inner join information_schema.columns AS col ON col.table_schema = se.schema_name AND col.table_name = se.table_name AND col.column_name = sef.field_name;

	-- D E L E T E
	delete from dictionary.screen_entity_fields where id in (
		select sef.id from dictionary.screen_entity_fields as sef
		inner join dictionary.screen_entities as se on se.id = sef.screen_entity_id and se.schema_name = _schema_name and se.table_name = _table_name and se.screen_id = _screen_id
		left join information_schema.columns as col on col.table_schema = se.schema_name and col.table_name = se.table_name and col.column_name = sef.field_name
		where col.column_name is null
	);
	*/
end;
$$;

truncate table app.screen_entity_fields

call app.usp_build_base_entity_fields('app', 'users', 4); -- user table
call app.usp_build_base_entity_fields('app', 'user_roles', 2); -- user table


select am.id, am.title, am.description, am.icon, am.parent_id, am.sort_order, sc.id as screen_id, sc."type" as screen_type FROM app.menus as am
left join app.screens as sc on am.id = sc.menu_id and sc.state = true and sc.is_primary = true
where am.state = true

-- and sc."type"  = 'TABLE'

select * from app.menus

alter table app.screen_entity_fields add column col_width numeric(6,2) default 0.00;
alter table app.screen_entity_fields drop column col_width;

select dsef.field_name, dsef.field_title, dsef.filterable, dsef.sortable, dsef.visible, dsef.col_index, dsef.col_width
from app.screen_entity_fields as dsef
inner join app.screen_entities as se on dsef.screen_entity_id = se.id
where se.multiple = true

select initcap('como')
