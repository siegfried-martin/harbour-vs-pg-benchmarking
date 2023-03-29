ALTER INDEX IF EXISTS search RENAME TO service_idx_search;

ALTER INDEX IF EXISTS type_id RENAME TO service_idx_type_id;

ALTER INDEX IF EXISTS result RENAME TO service_idx_result;

ALTER INDEX IF EXISTS invoice RENAME TO service_idx_invoice;

ALTER INDEX IF EXISTS batch RENAME TO service_idx_batch;

ALTER INDEX IF EXISTS vendor RENAME TO service_idx_vendor;

ALTER INDEX IF EXISTS dprtmnt RENAME TO service_idx_dprtmnt;

ALTER INDEX IF EXISTS rbatch RENAME TO service_idx_rbatch;

ALTER INDEX IF EXISTS vinvoice RENAME TO service_idx_vinvoice;

ALTER INDEX IF EXISTS result_dt RENAME TO service_idx_result_dt;

ALTER INDEX IF EXISTS owner RENAME TO service_idx_owner;

ALTER INDEX IF EXISTS crt_vend RENAME TO service_idx_crt_vend;

ALTER INDEX IF EXISTS crt_inv RENAME TO service_idx_crt_inv;

ALTER INDEX IF EXISTS created RENAME TO service_idx_created;

ALTER INDEX IF EXISTS expected RENAME TO service_idx_expected;

ALTER INDEX IF EXISTS priority RENAME TO service_idx_priority;

ALTER INDEX IF EXISTS munitaxven RENAME TO service_idx_munitaxven;

ALTER INDEX IF EXISTS sent_dt RENAME TO service_idx_sent_dt;

ALTER INDEX IF EXISTS vendordue RENAME TO service_idx_vendordue;

ALTER INDEX IF EXISTS crt_vend RENAME TO service_idx_crt_vend;

ALTER INDEX IF EXISTS aka RENAME TO service_idx_aka;

ALTER INDEX IF EXISTS linkedserv RENAME TO service_idx_linkedserv;

ALTER INDEX IF EXISTS subservice RENAME TO service_idx_subservice;

ALTER INDEX IF EXISTS tpteam RENAME TO service_idx_tpteam;

ALTER INDEX IF EXISTS test RENAME TO service_idx_test;

