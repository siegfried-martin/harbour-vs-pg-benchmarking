CREATE INDEX sc_party_idx_sc_pin_id ON client (sc_pin_id);

CREATE INDEX sc_dtype_idx_code3 ON sc_dtype (code3);

CREATE INDEX sc_dtype_idx_doc_type ON sc_dtype (upper(doc_type));

CREATE INDEX sc_dtype_idx_sc_sys_id ON sc_dtype (sc_sys_id);

CREATE INDEX sc_pin_idx_service_id ON client (service_id);

CREATE INDEX sc_pin_idx_instrument ON client (instrument);

CREATE INDEX sc_pin_idx_liber ON client (liber);

CREATE INDEX sc_pin_idx_page ON client (page);

CREATE INDEX sc_pin_idx_doc_date ON client (doc_date);

CREATE INDEX sc_pin_idx_taxid_id ON client (taxid_id);

CREATE INDEX sc_pin_idx_doc_type ON client (doc_type);

CREATE INDEX sc_pin_idx_name_id ON client (name_id);

CREATE INDEX sc_pin_idx_juri_id ON client (juri_id);