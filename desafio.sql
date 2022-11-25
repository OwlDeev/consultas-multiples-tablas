--ejercicio1

CREATE TABLE usuarios(
id SERIAL,
email VARCHAR,
nombre VARCHAR,
apellido VARCHAR,
rol CHAR(20)
);

insert into usuarios(email,nombre,apellido,rol) values ('alfonso@gmail.com', 'alfonso', 'sandoval', 'usuario');
insert into usuarios(email,nombre,apellido,rol) values ('romina@gmail.com', 'romina', 'gatito', 'administrador');
insert into usuarios(email,nombre,apellido,rol) values ('alan@gmail.com', 'alan', 'contreras', 'usuario');
insert into usuarios(email,nombre,apellido,rol) values ('karla@gmail.com', 'karla', 'sandoval', 'usuario');
insert into usuarios(email,nombre,apellido,rol) values ('roberto@gmail.com', 'roberto', 'del pino', 'administrador');

--ejercicio2

CREATE TABLE posts(
id serial,
titulo VARCHAR,
contenido TEXT,
fecha_creacion TIMESTAMP,
fecha_actualizacion TIMESTAMP,
destacado BOOLEAN,
usuarios_id BIGINT
);

insert into posts(titulo,contenido,fecha_creacion,fecha_actualizacion,destacado,usuarios_id) values ('correr temprano', 'levantarse a las 6', to_timestamp('02 May 2017', 'DD Mon YYYY'), to_timestamp('12 May 2017', 'DD Mon YYYY'),TRUE,2);
insert into posts(titulo,contenido,fecha_creacion,fecha_actualizacion,destacado,usuarios_id) values ('comer mucho', 'especialmente lasaña', to_timestamp('03 May 2017', 'DD Mon YYYY'), to_timestamp('13 May 2017', 'DD Mon YYYY'),FALSE,5);
insert into posts(titulo,contenido,fecha_creacion,fecha_actualizacion,destacado,usuarios_id) values ('jugar play', 'god of war', to_timestamp('04 May 2017', 'DD Mon YYYY'), to_timestamp('14 May 2017', 'DD Mon YYYY'),TRUE,3);
insert into posts(titulo,contenido,fecha_creacion,fecha_actualizacion,destacado,usuarios_id) values ('tocar guitarra', 'puro metal', to_timestamp('05 May 2017', 'DD Mon YYYY'), to_timestamp('15 May 2017', 'DD Mon YYYY'),TRUE,4);
insert into posts(titulo,contenido,fecha_creacion,fecha_actualizacion,destacado) values ('cocinar mucho', 'porotos', to_timestamp('06 May 2017', 'DD Mon YYYY'), to_timestamp('16 May 2017', 'DD Mon YYYY'),TRUE);

--ejercicio 3

CREATE TABLE comentarios(
id serial,
contenido VARCHAR,
fecha_creacion TIMESTAMP,
usuarios_id BIGINT,
post_id BIGINT
);

insert into comentarios(contenido,fecha_creacion,usuarios_id,post_id) values ('comentario1', to_timestamp('02 May 2017', 'DD Mon YYYY'),1,1);
insert into comentarios(contenido,fecha_creacion,usuarios_id,post_id) values ('comentario2', to_timestamp('03 May 2017', 'DD Mon YYYY'),2,1);
insert into comentarios(contenido,fecha_creacion,usuarios_id,post_id) values ('comentario3', to_timestamp('04 May 2017', 'DD Mon YYYY'),3,1);
insert into comentarios(contenido,fecha_creacion,usuarios_id,post_id) values ('comentario4', to_timestamp('05 May 2017', 'DD Mon YYYY'),1,2);
insert into comentarios(contenido,fecha_creacion,usuarios_id,post_id) values ('comentario5', to_timestamp('06 May 2017', 'DD Mon YYYY'),2,2);

---ultima parte

--Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas. nombre e email del usuario junto al título y contenido del post.
select usuarios.nombre, usuarios.email, posts.titulo, posts.contenido from usuarios
inner JOIN posts on usuarios.id = posts.usuarios_id

--Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id y debe ser seleccionado dinámicamente.
select posts.id, posts.titulo, posts.contenido, usuarios.id from posts
INNER JOIN usuarios on usuarios.id = posts.usuarios_id
WHERE usuarios.id = (SELECT usuarios.id from usuarios WHERE usuarios.rol = 'administrador' limit 1)

--Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario. 
select usuarios.id as id_usuarios, COUNT(posts.id) as cantidad_post, usuarios.email as email from posts
INNER JOIN usuarios on usuarios.id = posts.usuarios_id
WHERE posts.usuarios_id = usuarios.id
GROUP by id_usuarios,email

--Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.
select usuarios.email as email, COUNT(posts.id) as cantidad_post from usuarios
INNER JOIN posts on posts.usuarios_id = usuarios.id
where usuarios.id = posts.usuarios_id
GROUP BY email
ORDER BY cantidad_post DESC
LIMIT 1

--Muestra la fecha del último post de cada usuario.
select max(posts.fecha_creacion) as ultimo_post, usuarios.nombre as usuario from posts
INNER JOIN usuarios on posts.usuarios_id = usuarios.id
GROUP BY usuario

--Muestra el título y contenido del post (artículo) con más comentarios.
SELECT posts.titulo as posts_titulo, posts.contenido as posts_contenido, COUNT(comentarios.post_id) as cantidad_comentarios from posts
INNER JOIN comentarios on comentarios.post_id = posts.id
WHERE comentarios.post_id = posts.id
GROUP BY posts_titulo,posts_contenido
ORDER by cantidad_comentarios DESC
LIMIT 1

--Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
--de cada comentario asociado a los posts mostrados, junto con el email del usuario
--que lo escribió.
SELECT posts.titulo, posts.contenido, comentarios.contenido, usuarios.email from posts
INNER JOIN usuarios on usuarios.id = posts.usuarios_id
INNER JOIN comentarios on comentarios.post_id = posts.id
WHERE comentarios.post_id = posts.id

--Muestra el contenido del último comentario de cada usuario. FALTA

SELECT DISTINCT on (usuarios.id) as nombre_usuario, max(comentarios.fecha_creacion) as fecha_creacion from comentarios
INNER JOIN posts on posts.id = comentarios.post_id
INNER JOIN usuarios on usuarios.id = posts.usuarios_id
where comentarios.post_id = posts.id
and posts.usuarios_id = usuarios.id
GROUP BY nombre_usuario

--muestra los emails de los usuarios que no han escrito ningún comentario. FALTA

SELECT usuarios.email as email_usuarios from usuarios
INNER JOIN comentarios on comentarios.usuarios_id = usuarios.id
GROUP By email_usuarios, usuarios.id, comentarios.id
HAVING usuarios.id <> comentarios.id
