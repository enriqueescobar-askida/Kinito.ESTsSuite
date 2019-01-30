--
-- PostgreSQL EST database
--

--
-- Name: ESTlibs; Type: TABLE; Schema: public; Owner: eescobar; Tablespace: 
--
CREATE TABLE ESTlibs (
	id					integer					NOT NULL,
	name				character varying(64)	NOT NULL,
	organism			character varying(64)	NOT NULL,
	sex					character varying(10),
	vector				character varying(64)
);


--
-- Name: ReadGroups; Type: TABLE; Schema: public; Owner: eescobar; Tablespace: 
--
CREATE TABLE ReadGroups (
	id					integer					NOT NULL
);


--
-- Name: ReadSubGroups; Type: TABLE; Schema: public; Owner: eescobar; Tablespace: 
--
CREATE TABLE ReadSubGroups (
	id					integer					NOT NULL,
	clone_id			character varying(32)	NOT NULL,
	loc_pop_id character varying(64) NOT NULL,
	loc_pop_id_upp character varying(64) NOT NULL,
	create_time timestamp with time zone,
	last_updated_time timestamp with time zone,
	src_id integer
);


--
-- Name: snp; Type: TABLE; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE TABLE snp (
	snp_id integer NOT NULL,
	avg_heterozygosity real,
	het_se real,
	create_time timestamp with time zone,
	last_updated_time timestamp with time zone,
	cpg_code smallint,
	tax_id integer NOT NULL,
	validation_status smallint,
	exemplar_subsnp_id integer NOT NULL,
	univar_id integer NOT NULL,
	cnt_subsnp smallint NOT NULL,
	map_property smallint
);


--
-- Name: snpsubsnplink; Type: TABLE; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE TABLE snpsubsnplink (
	subsnp_id integer NOT NULL,
	snp_id integer NOT NULL,
	substrand_reversed_flag smallint NOT NULL,
	create_time timestamp with time zone,
	last_updated_time timestamp with time zone,
	build_id integer,
	"comment" character varying(255)
);


--
-- Name: subpop; Type: TABLE; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE TABLE subpop (
	batch_id integer NOT NULL,
	subsnp_id integer NOT NULL,
	pop_id integer NOT NULL,
	"type" character(3) NOT NULL,
	samplesize integer NOT NULL,
	submitted_strand_code smallint,
	submitted_rs integer,
	allele_flag smallint,
	ambiguity_status smallint,
	sub_heterozygosity real,
	est_heterozygosity real,
	est_het_se_sq real,
	last_updated_time timestamp with time zone NOT NULL,
	observed character varying(255),
	sub_het_se_sq real,
	subpop_id integer NOT NULL
);


--
-- Name: subpopallele; Type: TABLE; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE TABLE subpopallele (
	batch_id integer NOT NULL,
	subsnp_id integer NOT NULL,
	pop_id integer NOT NULL,
	allele character(1) NOT NULL,
	other character varying(255),
	freq real,
	cnt_int integer,
	freq_min real,
	freq_max real,
	data_src character varying(6),
	"type" character(3),
	last_updated_time timestamp with time zone,
	allele_flag smallint,
	cnt real,
	allele_id integer,
	subpop_id integer NOT NULL
);


--
-- Name: subsnp; Type: TABLE; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE TABLE subsnp (
	subsnp_id integer NOT NULL,
	known_snp_handle character varying(20),
	known_snp_loc_id character varying(64),
	known_snp_loc_id_upp character varying(64),
	batch_id integer NOT NULL,
	loc_snp_id character varying(64),
	loc_snp_id_upp character varying(64),
	synonym_names character varying(255),
	loc_sts_id character varying(64),
	loc_sts_id_upp character varying(64),
	segregate character(1) NOT NULL,
	indiv_homozygosity_detected character(1),
	pcr_confirmed_ind character(1),
	gene_name character varying(64),
	sequence_len integer,
	samplesize integer,
	expressed_sequence_ind character(1),
	somatic_ind character(1),
	sub_locus_id integer,
	create_time timestamp with time zone,
	last_updated_time timestamp with time zone,
	ancestral_allele character varying(255),
	cpg_code smallint,
	variation_id integer,
	top_or_bot_strand character(1),
	validation_status smallint,
	snp_id integer,
	tax_id integer NOT NULL,
	chr_id smallint
);


--
-- Name: population_pkey; Type: CONSTRAINT; Schema: public; Owner: eescobar; Tablespace: 
--

ALTER TABLE ONLY population
	ADD CONSTRAINT population_pkey PRIMARY KEY (pop_id);


--
-- Name: snp_pkey; Type: CONSTRAINT; Schema: public; Owner: eescobar; Tablespace: 
--

ALTER TABLE ONLY snp
	ADD CONSTRAINT snp_pkey PRIMARY KEY (snp_id);


--
-- Name: subpop_pkey; Type: CONSTRAINT; Schema: public; Owner: eescobar; Tablespace: 
--

ALTER TABLE ONLY subpop
	ADD CONSTRAINT subpop_pkey PRIMARY KEY (subpop_id);


--
-- Name: subsnp_pkey; Type: CONSTRAINT; Schema: public; Owner: eescobar; Tablespace: 
--

ALTER TABLE ONLY subsnp
	ADD CONSTRAINT subsnp_pkey PRIMARY KEY (subsnp_id);


--
-- Name: b126_snpcontiglocusid_36_1_snp_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX b126_snpcontiglocusid_36_1_snp_idx ON b126_snpcontiglocusid_36_1 USING btree (snp_id);


--
-- Name: freqsummarybysspop_pop_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX freqsummarybysspop_pop_idx ON freqsummarybysspop USING btree (pop_id);


--
-- Name: freqsummarybysspop_subsnp_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX freqsummarybysspop_subsnp_idx ON freqsummarybysspop USING btree (subsnp_id);


--
-- Name: snpsubsnplink_snp_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX snpsubsnplink_snp_idx ON snpsubsnplink USING btree (snp_id);


--
-- Name: snpsubsnplink_subsnp_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX snpsubsnplink_subsnp_idx ON snpsubsnplink USING btree (subsnp_id);


--
-- Name: subpop_pop_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX subpop_pop_idx ON subpop USING btree (pop_id);


--
-- Name: subpop_subsnp_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX subpop_subsnp_idx ON subpop USING btree (subsnp_id);


--
-- Name: subpopallele_pop_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX subpopallele_pop_idx ON subpopallele USING btree (pop_id);


--
-- Name: subpopallele_subpop_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX subpopallele_subpop_idx ON subpopallele USING btree (subpop_id);


--
-- Name: subpopallele_subsnp_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX subpopallele_subsnp_idx ON subpopallele USING btree (subsnp_id);


--
-- Name: subsnp_snp_idx; Type: INDEX; Schema: public; Owner: eescobar; Tablespace: 
--

CREATE INDEX subsnp_snp_idx ON subsnp USING btree (snp_id);


--
-- Name: b126_snpcontiglocusid_36_1_snp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eescobar
--

ALTER TABLE ONLY b126_snpcontiglocusid_36_1
	ADD CONSTRAINT b126_snpcontiglocusid_36_1_snp_id_fkey FOREIGN KEY (snp_id) REFERENCES snp(snp_id);


--
-- Name: freqsummarybysspop_pop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eescobar
--

ALTER TABLE ONLY freqsummarybysspop
	ADD CONSTRAINT freqsummarybysspop_pop_id_fkey FOREIGN KEY (pop_id) REFERENCES population(pop_id);


--
-- Name: freqsummarybysspop_subsnp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eescobar
--

ALTER TABLE ONLY freqsummarybysspop
	ADD CONSTRAINT freqsummarybysspop_subsnp_id_fkey FOREIGN KEY (subsnp_id) REFERENCES subsnp(subsnp_id);


--
-- Name: snpsubsnplink_snp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eescobar
--

ALTER TABLE ONLY snpsubsnplink
	ADD CONSTRAINT snpsubsnplink_snp_id_fkey FOREIGN KEY (snp_id) REFERENCES snp(snp_id);


--
-- Name: snpsubsnplink_subsnp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eescobar
--

ALTER TABLE ONLY snpsubsnplink
	ADD CONSTRAINT snpsubsnplink_subsnp_id_fkey FOREIGN KEY (subsnp_id) REFERENCES subsnp(subsnp_id);


--
-- Name: subpop_pop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eescobar
--

ALTER TABLE ONLY subpop
	ADD CONSTRAINT subpop_pop_id_fkey FOREIGN KEY (pop_id) REFERENCES population(pop_id);


--
-- Name: subpop_subsnp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eescobar
--

ALTER TABLE ONLY subpop
	ADD CONSTRAINT subpop_subsnp_id_fkey FOREIGN KEY (subsnp_id) REFERENCES subsnp(subsnp_id);


--
-- Name: subpopallele_pop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eescobar
--

ALTER TABLE ONLY subpopallele
	ADD CONSTRAINT subpopallele_pop_id_fkey FOREIGN KEY (pop_id) REFERENCES population(pop_id);


--
-- Name: subpopallele_subpop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eescobar
--

ALTER TABLE ONLY subpopallele
	ADD CONSTRAINT subpopallele_subpop_id_fkey FOREIGN KEY (subpop_id) REFERENCES subpop(subpop_id);


--
-- Name: subpopallele_subsnp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eescobar
--

ALTER TABLE ONLY subpopallele
	ADD CONSTRAINT subpopallele_subsnp_id_fkey FOREIGN KEY (subsnp_id) REFERENCES subsnp(subsnp_id);


--
-- PostgreSQL EST database complete
--

