create table roles(
roleId SERIAL PRIMARY KEY,
rolename varchar(255),
isystemrole bool
);

create table users(
userId SERIAL primary key,
fname varchar(255),
roleId int REFERENCES roles(roleId)
) 

create table products (
pid serial primary key,
userId int references users(userId),
pname varchar (50)
)

create table categories(
cid serial primary key ,
cname varchar (255),
pid int references products(pid)
) 

insert into roles(roleId,rolename,isystemrole) values(1,'Admin',true) 
insert into roles(roleId,rolename,isystemrole) values(2,'User1',false) 
insert into roles(roleId,rolename,isystemrole) values(3,'User2',false) 
select * from roles

insert into users(fname,roleId) values ('Akash',2)
insert into users(fname,roleId) values ('Astitva',3)

select * from users;


create or replace view user_product as
select users.userId , users.fname ,products.pname from 
users inner join products 
on users.userId = products.userId

select * from user_product



create table pid_audits (
pid_audit SERIAL PRIMARY KEY,
pid INT NOT NULL,
pname varchar(100),
edit_date TIMESTAMP NOT NULL
)


CREATE OR REPLACE FUNCTION fn_replace_pname()
		RETURNS TRIGGER
		LANGUAGE PLPGSQL
			as
			$$
				BEGIN
				if NEW.pname <> OLD.pname THEN
				insert into pid_audits(pid,pname,edit_date) values (OLD.pid,OLD.pname,NOW());
		END IF; 
		      RETURN NEW;
    END;
    $$


  CREATE TRIGGER trigger_pname_changes
  BEFORE     
  UPDATE
  ON products
  FOR EACH ROW
     EXECUTE PROCEDURE fn_replace_pname()


     
update products set pname = 'iphone13' where pid=1  
select * from pid_audits;