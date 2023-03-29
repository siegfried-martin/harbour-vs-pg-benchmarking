CREATE INDEX service_idx_search ON service (search_id);

CREATE INDEX service_idx_type_id ON service (type_id);

CREATE INDEX service_idx_result ON service (result_id);

CREATE INDEX service_idx_invoice ON service (invoice_id);

CREATE INDEX service_idx_batch ON service (batch_id);

CREATE INDEX service_idx_vendor ON service (vendor_id);

CREATE INDEX service_idx_dprtmnt ON service (dprtmnt_id);

CREATE INDEX service_idx_rbatch ON service (rbatch_id);

CREATE INDEX service_idx_vinvoice ON service (vinvoiceid);

CREATE INDEX service_idx_result_dt ON service (result_dt);

CREATE INDEX service_idx_owner ON service (owner);

CREATE INDEX service_idx_crt_vend ON service (crt_vend);

CREATE INDEX service_idx_crt_inv ON service (crt_inv);

CREATE INDEX service_idx_created ON service (created_dt);

CREATE INDEX service_idx_expected ON service (expected);

CREATE INDEX service_idx_priority ON service (priority);

CREATE INDEX service_idx_munitaxven ON service (munitaxven);

CREATE INDEX service_idx_sent_dt ON service (sent_dt);

CREATE INDEX service_idx_vendordue ON service (vendordue);

CREATE INDEX service_idx_aka ON service (upper(aka));

CREATE INDEX service_idx_linkedserv ON service (linkedserv);

CREATE INDEX service_idx_subservice ON service (subservice);

CREATE INDEX service_idx_tpteam ON service (tpteam);

CREATE INDEX service_idx_test ON service (test);

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

CREATE INDEX client_idx_code ON client (upper(code));

CREATE INDEX client_idx_name ON client (upper(name));

CREATE INDEX client_idx_team ON client (team);

CREATE INDEX client_idx_isclosings ON client (isclosings);

CREATE INDEX client_idx_frs_theirs ON client (frs_theirs);

CREATE INDEX code ON client (upper(code));

CREATE INDEX sc_party_idx_sc_pin_id ON sc_party (sc_pin_id);

CREATE INDEX sc_dtype_idx_code3 ON sc_dtype (code3);

CREATE INDEX sc_dtype_idx_doc_type ON sc_dtype (upper(doc_type));

CREATE INDEX sc_dtype_idx_sc_sys_id ON sc_dtype (sc_sys_id);

CREATE INDEX sc_pin_idx_service_id ON sc_pin (service_id);

CREATE INDEX sc_pin_idx_instrument ON sc_pin (instrument);

CREATE INDEX sc_pin_idx_liber ON sc_pin (liber);

CREATE INDEX sc_pin_idx_page ON sc_pin (page);

CREATE INDEX sc_pin_idx_doc_date ON sc_pin (doc_date);

CREATE INDEX sc_pin_idx_taxid_id ON sc_pin (taxid_id);

CREATE INDEX sc_pin_idx_doc_type ON sc_pin (doc_type);

CREATE INDEX sc_pin_idx_name_id ON sc_pin (name_id);

CREATE INDEX sc_pin_idx_juri_id ON sc_pin (juri_id);

