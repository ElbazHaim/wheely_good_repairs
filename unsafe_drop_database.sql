use master
alter database car_repair_shop set single_user with rollback immediate
alter database car_repair_shop set multi_user
DROP DATABASE car_repair_shop