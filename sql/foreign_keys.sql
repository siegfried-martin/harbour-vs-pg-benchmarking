update sc_pin
set doc_type = NULL
where recno in (
	select other.recno
	from sc_pin other
	left outer join sc_dtype on other.doc_type = sc_dtype.recno
	where sc_dtype.recno is null and other.doc_type is not null
);

update sc_party
set sc_pin_id = NULL
where recno in (
	select other.recno
	from sc_party other
	left outer join sc_pin on other.sc_pin_id = sc_pin.recno
	where sc_pin.recno is null and other.sc_pin_id is not null
);

update sc_pin
set service_id = NULL
where recno in (
	select other.recno
	from sc_pin other
	left outer join service on other.service_id = service.id_
	where service.id_ is null and other.service_id is not null
);

update service
set vendor_id = NULL
where id_ in (
	select other.id_
	from service other
	left outer join vendor on other.vendor_id = vendor.recno
	where vendor.recno is null and other.vendor_id is not null
);

update service
set result_id = NULL
where id_ in (
	select other.id_
	from service other
	left outer join result on other.result_id = result.recno
	where result.recno is null and other.result_id is not null
);

update service
set search_id = NULL
where id_ in (
	select other.id_
	from service other
	left outer join search on other.search_id = search.id_
	where search.id_ is null and other.search_id is not null
);

update search
set client_id = NULL
where id_ in (
	select other.id_
	from search other
	left outer join client on other.client_id = client.recno
	where client.recno is null and other.client_id is not null
);

ALTER TABLE search
ADD CONSTRAINT fk_search_client_id 
FOREIGN KEY (client_id)
REFERENCES client (recno);

ALTER TABLE service
ADD CONSTRAINT fk_service_search_id
FOREIGN KEY (search_id)
REFERENCES search (id_);

ALTER TABLE service
ADD CONSTRAINT fk_service_result_id
FOREIGN KEY (result_id)
REFERENCES result (recno);

ALTER TABLE service
ADD CONSTRAINT fk_service_vendor_id
FOREIGN KEY (vendor_id)
REFERENCES vendor (recno);

ALTER TABLE sc_pin
ADD CONSTRAINT fk_sc_pin_service_id
FOREIGN KEY (service_id)
REFERENCES service (id_);

ALTER TABLE sc_pin
ADD CONSTRAINT fk_sc_pin_doc_type
FOREIGN KEY (doc_type)
REFERENCES sc_dtype (recno);

ALTER TABLE sc_party
ADD CONSTRAINT fk_sc_party_sc_pin_id
FOREIGN KEY (sc_pin_id)
REFERENCES sc_pin (recno);
