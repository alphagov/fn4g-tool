CREATE TABLE countries
(
    id serial PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE regions
(
    id serial PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE organisations
(
    id serial PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    country_id integer NOT NULL,
    region_id integer NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT organisations_region_id_fkey FOREIGN KEY (region_id)
        REFERENCES regions(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT organisations_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES countries(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE users
(
    id serial PRIMARY KEY,
    email VARCHAR UNIQUE NOT NULL,
    encrypted_password VARCHAR NOT NULL,
    reset_password_token VARCHAR DEFAULT NULL,
    reset_password_sent_at timestamp without time zone DEFAULT NULL,
    remember_created_at timestamp without time zone DEFAULT NULL,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone DEFAULT NULL,
    last_sign_in_at timestamp without time zone DEFAULT NULL,
    current_sign_in_ip VARCHAR DEFAULT NULL,
    last_sign_in_ip VARCHAR DEFAULT NULL,
    confirmation_token VARCHAR DEFAULT NULL,
    confirmed_at timestamp without time zone DEFAULT NULL,
    confirmation_sent_at timestamp without time zone DEFAULT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT NOW(),
    updated_at timestamp without time zone NOT NULL DEFAULT NOW(),
    organisation_id integer NOT NULL,
    name VARCHAR,
    mobile VARCHAR,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token VARCHAR DEFAULT NULL,
    locked_at timestamp without time zone DEFAULT NULL,
    CONSTRAINT users_organisation_id_fkey FOREIGN KEY (organisation_id)
        REFERENCES organisations(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE roles
(
    id serial PRIMARY KEY,
    role_name VARCHAR UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE user_roles
(
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    grant_date TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT account_role_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES roles (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT account_role_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES users (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE assessment_types
(
    id serial PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE questionsets
(
    id serial PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    assessment_type_id integer NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT questionset_assessment_type_id_fkey FOREIGN KEY (assessment_type_id)
        REFERENCES assessment_types(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE sections
(
    id serial PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    description VARCHAR DEFAULT NULL,
    questionset_id integer NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT section_questionset_id_fkey FOREIGN KEY (questionset_id)
        REFERENCES questionsets(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE question_categories
(
    id serial PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE question_types
(
    id serial PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE questions
(
    id serial PRIMARY KEY,
    question VARCHAR NOT NULL,
    section_id integer NOT NULL,
    question_category_id integer NOT NULL,
    question_type_id integer NOT NULL,
    index integer DEFAULT NULL,
    reference VARCHAR DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT question_section_unique_index UNIQUE (question, section_id),
    CONSTRAINT question_section_id_fkey FOREIGN KEY (section_id)
        REFERENCES sections(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT question_category_id_fkey FOREIGN KEY (question_category_id)
        REFERENCES question_categories(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT question_type_id_fkey FOREIGN KEY (question_type_id)
        REFERENCES question_types(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE trinomial_options
(
    id serial PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE binomial_options
(
    id serial PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE assessments
(
    id serial PRIMARY KEY,
    assessment_type_id integer NOT NULL,
    organisation_id integer NOT NULL,
    user_id integer NOT NULL,
    started_at TIMESTAMP NOT NULL DEFAULT NOW(),
    completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT assessment_type_id_fkey FOREIGN KEY (assessment_type_id)
        REFERENCES assessment_types(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT assessment_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES users(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT assessment_organisation_id_fkey FOREIGN KEY (organisation_id)
        REFERENCES organisations(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE answers
(
    id serial PRIMARY KEY,
    assessment_id integer NOT NULL,
    question_id integer NOT NULL,
    trinomial_option_id integer DEFAULT NULL,
    binomial_option_id integer DEFAULT NULL,
    freetext TEXT DEFAULT NULL,
    numerical numeric DEFAULT NULL,
    percentage numeric DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT answer_assessment_id_fkey FOREIGN KEY (assessment_id)
        REFERENCES assessments(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT answer_question_id_fkey FOREIGN KEY (question_id)
        REFERENCES questions(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT answer_trinomial_option_id_fkey FOREIGN KEY (trinomial_option_id)
        REFERENCES trinomial_options(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT answer_binomial_option_id_fkey FOREIGN KEY (binomial_option_id)
        REFERENCES binomial_options(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
