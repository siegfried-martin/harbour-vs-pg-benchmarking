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



alter table search
add constraint fk_search_client
foreign key (client_id)
references client (recno);

alter table service
add constraint fk_service_search
foreign key (search_id)
references search (id_);

alter table service
add constraint fk_service_result
foreign key (result_id)
references result (recno);

alter table service
add constraint fk_service_vendor
foreign key (vendor_id)
references vendor (recno);