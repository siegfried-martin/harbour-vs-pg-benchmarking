CREATE INDEX vendor_idx_code ON vendor (upper(code));

CREATE INDEX vendor_idx_name ON vendor (upper(name));

CREATE INDEX vendor_idx_company ON vendor (upper(company));

CREATE INDEX vendor_idx_ask ON vendor (ask);

CREATE INDEX vendor_idx_theirs ON vendor (frs_theirs);

CREATE INDEX vendor_idx_canexam ON vendor (canexam);

CREATE INDEX vendor_idx_canpor ON vendor (canpor);

CREATE INDEX vendor_idx_county_id ON vendor (county_id);

CREATE INDEX vendor_idx_mc_closer ON vendor (mc_closer);

CREATE INDEX vendor_idx_tpgroup ON vendor (tpgroup);

CREATE INDEX vendor_idx_manager ON vendor (manager);
