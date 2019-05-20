BEGIN

    ORDS.ENABLE_SCHEMA(p_enabled => TRUE,
                       p_schema => 'SOE',
                       p_url_mapping_type => 'BASE_PATH',
                       p_url_mapping_pattern => 'soe',
                       p_auto_rest_auth => FALSE);

    commit;

END;
/

BEGIN

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'SOE',
                       p_object => 'ORDERS',
                       p_object_type => 'TABLE',
                       p_object_alias => 'orders',
                       p_auto_rest_auth => FALSE);

    commit;

END;
/
