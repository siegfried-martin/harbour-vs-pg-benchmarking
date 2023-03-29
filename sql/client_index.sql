CREATE INDEX client_idx_code ON client (upper(code));

CREATE INDEX client_idx_name ON client (upper(name));

CREATE INDEX client_idx_team ON client (team);

CREATE INDEX client_idx_isclosings ON client (isclosings);

CREATE INDEX client_idx_frs_theirs ON client (frs_theirs);
