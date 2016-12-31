CREATE OR REPLACE FUNCTION cpf_check(cpf_str TEXT)
RETURNS BOOLEAN AS $$
-- Função para validação numérica de CPF
-- v0.01.01
-- by Ronaldo Ferreira de Lima aka jimmy <jimmy.tty@gmail.com>
DECLARE
    peso1 CONSTANT INTEGER[] := ARRAY[10,  9, 8, 7, 6, 5, 4, 3, 2];
    peso2 CONSTANT INTEGER[] := ARRAY[11, 10, 9, 8, 7, 6, 5, 4, 3, 2];
    cpf_length CONSTANT INTEGER := 11;
    cpf_unfmt           TEXT;
    cpf_vec             TEXT[];
    check_status        BOOLEAN;
    dv1                 INTEGER;
    dv2                 INTEGER;
    subscript           INTEGER;
    digito              INTEGER;
    peso                INTEGER;
    produto             INTEGER;

BEGIN

    cpf_unfmt := TRANSLATE(cpf_str, TRANSLATE(cpf_str, '0123456789', ''), '');

    IF LENGTH(cpf_unfmt) = 0 OR LENGTH(cpf_unfmt) > cpf_length THEN
        RETURN FALSE;
    END IF;

    IF cpf_unfmt::BIGINT = 0 THEN
        RETURN FALSE;
    END IF;

    cpf_unfmt := LPAD(cpf_unfmt, cpf_length, '0');

    cpf_vec := REGEXP_SPLIT_TO_ARRAY(cpf_unfmt, '');

    dv1 := 0;
    FOR subscript IN SELECT GENERATE_SUBSCRIPTS(peso1, 1) LOOP
        peso    := peso1[subscript];
        digito  := cpf_vec[subscript];
        produto := peso * digito;
        dv1     := dv1 + produto;
    END LOOP;
    dv1 := dv1 % 11;
    dv1 := CASE WHEN dv1 < 2 THEN 0 ELSE 11 - dv1 END;

    dv2 := 0;
    FOR subscript IN SELECT GENERATE_SUBSCRIPTS(peso2, 1) LOOP
        peso    := peso2[subscript];
        digito  := cpf_vec[subscript];
        produto := peso * digito;
        dv2     := dv2 + produto;
    END LOOP;
    dv2 := dv2 % 11;
    dv2 := CASE WHEN dv2 < 2 THEN 0 ELSE 11 - dv2 END;

    IF dv1 = cpf_vec[10]::INTEGER AND dv2 = cpf_vec[11]::INTEGER THEN
        check_status = TRUE;
    ELSE
        check_status = FALSE;
    END IF;

    RETURN check_status;
END
$$ LANGUAGE PLPGSQL IMMUTABLE;
