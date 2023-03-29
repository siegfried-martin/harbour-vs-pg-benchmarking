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

