--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: a_user; Type: TABLE; Schema: public; Owner: deeannkendrick
--

CREATE TABLE a_user (
    id integer NOT NULL,
    name character varying,
    email character varying,
    password character varying,
    user_name character varying NOT NULL,
    bio character varying
);


ALTER TABLE a_user OWNER TO deeannkendrick;

--
-- Name: follow; Type: TABLE; Schema: public; Owner: deeannkendrick
--

CREATE TABLE follow (
    follower_id integer,
    followee_id integer
);


ALTER TABLE follow OWNER TO deeannkendrick;

--
-- Name: tweet; Type: TABLE; Schema: public; Owner: deeannkendrick
--

CREATE TABLE tweet (
    id integer NOT NULL,
    tweet character varying,
    user_id integer NOT NULL,
    time_stamp timestamp without time zone
);


ALTER TABLE tweet OWNER TO deeannkendrick;

--
-- Name: tweet_id_seq; Type: SEQUENCE; Schema: public; Owner: deeannkendrick
--

CREATE SEQUENCE tweet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tweet_id_seq OWNER TO deeannkendrick;

--
-- Name: tweet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: deeannkendrick
--

ALTER SEQUENCE tweet_id_seq OWNED BY tweet.id;


--
-- Name: untitled_table_id_seq; Type: SEQUENCE; Schema: public; Owner: deeannkendrick
--

CREATE SEQUENCE untitled_table_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE untitled_table_id_seq OWNER TO deeannkendrick;

--
-- Name: untitled_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: deeannkendrick
--

ALTER SEQUENCE untitled_table_id_seq OWNED BY a_user.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: deeannkendrick
--

ALTER TABLE ONLY a_user ALTER COLUMN id SET DEFAULT nextval('untitled_table_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: deeannkendrick
--

ALTER TABLE ONLY tweet ALTER COLUMN id SET DEFAULT nextval('tweet_id_seq'::regclass);


--
-- Data for Name: a_user; Type: TABLE DATA; Schema: public; Owner: deeannkendrick
--

COPY a_user (id, name, email, password, user_name, bio) FROM stdin;
8	DeeAnn	deeann@gmail.com	$2b$12$uzoYjR6xCwdVXzWH9rtyhulrZThUJjR2bazjseUpdtqANn2Sla2Ey	dkendrick	Welcome to my Chirp
9	Carolyn	carol@gmail.com	$2b$12$5Ym.MPHx6n7g6fqXmnYwsu362Lh.g2OIK58uXIk8ui3T/ZW/JrR0u	csdaniel	Sauce lyfe
10	Cody	cody@gmail.com	$2b$12$O1yRRmcJd3yhAcM/L8Rk.ObtQtoWtsAgbADocMacqPm5CAuEEls.O	scrumlord	
11	Toby	tobes@gmail.com	$2b$12$dfY9WrnMqSx7TzTw.oCg.uI8k8BbXdPjxn1Lv0lgEiu5AKOu1c9NO	tobes	Instructor at DC
12	Will	will@gmail.com	$2b$12$mlRWw15xIH1xOUgGkVbH1e.y4LKkOmo8Wwb1BZ68inqjarOTdf12W	willz	
\.


--
-- Data for Name: follow; Type: TABLE DATA; Schema: public; Owner: deeannkendrick
--

COPY follow (follower_id, followee_id) FROM stdin;
9	8
8	9
8	10
9	10
8	11
9	11
11	10
11	8
12	8
12	10
12	11
11	8
10	8
10	11
\.


--
-- Data for Name: tweet; Type: TABLE DATA; Schema: public; Owner: deeannkendrick
--

COPY tweet (id, tweet, user_id, time_stamp) FROM stdin;
1	Hello Twitter	8	2012-12-22 00:00:00
2	Looking forward to a Vacation!	8	2016-07-26 00:00:00
3	Making Chirp today	8	2016-07-26 00:00:00
8	hello	8	2016-07-27 13:52:09.539503
9	what's up	8	2016-07-27 13:53:00.040062
12	finally	8	2016-07-27 15:13:32.079043
7	And extra sauce please	9	2016-05-02 00:00:00
6	Could really go for some Chipotle right about now	9	2016-06-16 00:00:00
4	Gotta hit the Poke Park later and find some Pokemon	10	2016-06-22 00:00:00
5	Debug, Debug, and Debug some more	11	2012-12-22 00:00:00
13	heyyyy	10	2016-07-28 13:49:20.906926
11	sup	12	2016-07-27 13:53:00.040062
\.


--
-- Name: tweet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: deeannkendrick
--

SELECT pg_catalog.setval('tweet_id_seq', 14, true);


--
-- Name: untitled_table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: deeannkendrick
--

SELECT pg_catalog.setval('untitled_table_id_seq', 12, true);


--
-- Name: tweet_pkey; Type: CONSTRAINT; Schema: public; Owner: deeannkendrick
--

ALTER TABLE ONLY tweet
    ADD CONSTRAINT tweet_pkey PRIMARY KEY (id);


--
-- Name: untitled_table_email_key; Type: CONSTRAINT; Schema: public; Owner: deeannkendrick
--

ALTER TABLE ONLY a_user
    ADD CONSTRAINT untitled_table_email_key UNIQUE (email);


--
-- Name: untitled_table_name_key; Type: CONSTRAINT; Schema: public; Owner: deeannkendrick
--

ALTER TABLE ONLY a_user
    ADD CONSTRAINT untitled_table_name_key UNIQUE (name);


--
-- Name: untitled_table_pkey; Type: CONSTRAINT; Schema: public; Owner: deeannkendrick
--

ALTER TABLE ONLY a_user
    ADD CONSTRAINT untitled_table_pkey PRIMARY KEY (id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

