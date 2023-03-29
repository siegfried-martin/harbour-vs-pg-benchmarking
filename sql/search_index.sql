CREATE INDEX search_idx_created_dt ON search (created_dt);

CREATE INDEX search_idx_received ON search (received);

CREATE INDEX search_idx_ship_to ON search (ship_to);

CREATE INDEX search_idx_tax_id ON search (upper(tax_id));

CREATE INDEX search_idx_completed ON search (completed);

CREATE INDEX search_idx_name ON search (upper(name));

CREATE INDEX search_idx_ssn ON search (ssn);

CREATE INDEX search_idx_client ON search (client_id);

CREATE INDEX search_idx_web ON search (web_id);

CREATE INDEX search_idx_invoice ON search (invoice_id);

CREATE INDEX search_idx_created ON search (created);

CREATE INDEX search_idx_upload_id ON search (upload_id);

CREATE INDEX search_idx_driver_lic ON search (driver_lic);

CREATE INDEX search_idx_project ON search (upper(project_no));

CREATE INDEX search_idx_address ON search (upper(address));
