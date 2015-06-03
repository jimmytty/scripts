CREATE OR REPLACE FUNCTION cnpj_check(cnpj_str TEXT)
RETURNS BOOLEAN AS $$
-- Função para validação numérica de CNPJ
-- v0.01
-- by Ronaldo Ferreira de Lima aka jimmy <jimmy.tty@gmail.com>
DECLARE
    peso1 CONSTANT INTEGER[] := ARRAY[5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    peso2 CONSTANT INTEGER[] := ARRAY[6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    cnpj_length CONSTANT INTEGER := 14;
    cnpj_unfmt           TEXT;
    cnpj_vec             TEXT[];
    check_status         BOOLEAN;
    dv1                  INTEGER;
    dv2                  INTEGER;
    subscript            INTEGER;
    digito                INTEGER;
    peso                 INTEGER;
    produto              INTEGER;

BEGIN

    cnpj_unfmt := TRANSLATE(cnpj_str, TRANSLATE(cnpj_str, '0123456789', ''), '');

    IF LENGTH(cnpj_unfmt) = 0 OR LENGTH(cnpj_unfmt) > cnpj_length THEN
        RAISE 'length';
        RETURN FALSE;
    END IF;

    cnpj_unfmt := LPAD(cnpj_unfmt, cnpj_length, '0');

    cnpj_vec := REGEXP_SPLIT_TO_ARRAY(cnpj_unfmt, '');

    dv1 := 0;
    FOR subscript IN SELECT GENERATE_SUBSCRIPTS(peso1, 1) LOOP
        peso    := peso1[subscript];
        digito  := cnpj_vec[subscript];
        produto := peso * digito;
        dv1     := dv1 + produto;
    END LOOP;
    dv1 := dv1 % 11;
    dv1 := CASE WHEN dv1 < 2 THEN 0 ELSE 11 - dv1 END;

    dv2 := 0;
    FOR subscript IN SELECT GENERATE_SUBSCRIPTS(peso2, 1) LOOP
        peso    := peso2[subscript];
        digito  := cnpj_vec[subscript];
        produto := peso * digito;
        dv2     := dv2 + produto;
    END LOOP;
    dv2 := dv2 % 11;
    dv2 := CASE WHEN dv2 < 2 THEN 0 ELSE 11 - dv2 END;

    IF dv1 = cnpj_vec[13]::INTEGER AND dv2 = cnpj_vec[14]::INTEGER THEN
        check_status = TRUE;
    ELSE
        check_status = FALSE;
    END IF;

    RETURN check_status;
END
$$ LANGUAGE PLPGSQL IMMUTABLE;
