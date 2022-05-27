CREATE OR REPLACE VIEW V_SALDOS AS
    SELECT cliente.identificacion, cuenta.iban, cuenta_referencia.saldo, divisa.abreviatura, divisa.cambio_euro
    FROM cliente 
    JOIN cuenta_fintech ON cliente.id = cuenta_fintech.cliente_id
    JOIN cuenta ON cuenta_fintech.cuenta_cuenta_id = cuenta.cuenta_id
    JOIN pooled_account ON cuenta_fintech.cuenta_cuenta_id = pooled_account.cuenta_fintech_id
    JOIN  depositar_en ON pooled_account.cuenta_fintech_id = depositar_en.pool_id
    JOIN cuenta_referencia ON depositar_en.cuenta_ref_id = cuenta_referencia.cuenta_cuenta_id
    JOIN divisa ON cuenta_referencia.divisa_abreviatura = divisa.abreviatura
    
    UNION ALL 
    
    SELECT cliente.identificacion, cuenta.iban, cuenta_referencia.saldo, divisa.abreviatura, divisa.cambio_euro
    FROM cliente 
    JOIN cuenta_fintech ON cliente.id = cuenta_fintech.cliente_id
    JOIN cuenta ON cuenta_fintech.cuenta_cuenta_id = cuenta.cuenta_id
    JOIN segregada ON cuenta_fintech.cuenta_cuenta_id = segregada.cuenta_fintech_id
    JOIN cuenta_referencia ON segregada.cuenta_ref_id = cuenta_referencia.cuenta_cuenta_id
    JOIN divisa ON cuenta_referencia.divisa_abreviatura = divisa.abreviatura
    ;