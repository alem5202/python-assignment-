CREATE OR REPLACE PACKAGE horizontal_miniterm_generator IS
  TYPE predicate_record IS RECORD (
    relation VARCHAR2(30),
    attributes VARCHAR2(200)
  );

  TYPE predicate_table IS TABLE OF predicate_record;

  TYPE fragment_table IS TABLE OF VARCHAR2(200);

  PROCEDURE generate_fragments (
    p_predicates predicate_table,
    o_fragments OUT fragment_table
  );
END horizontal_miniterm_generator;
/

CREATE OR REPLACE PACKAGE BODY horizontal_miniterm_generator AS
  PROCEDURE generate_fragments (
    p_predicates predicate_table,
    o_fragments OUT fragment_table
  ) IS
    l_relation VARCHAR2(30);
    l_attributes VARCHAR2(200);
  BEGIN
    -- Initialize the output collection
    o_fragments := fragment_table();

    FOR i IN 1..p_predicates.COUNT LOOP
      -- Extract relation name and attributes
      l_relation := p_predicates(i).relation;
      l_attributes := REGEXP_SUBSTR(p_predicates(i).attributes, '([^,]+)', 1, 1, 'i');

      -- Construct HORIZONTAL miniterm fragment
      o_fragments.EXTEND;
      o_fragments(o_fragments.LAST) := 'HORIZONTAL R_' || l_relation || '(' || l_attributes || ')';
    END LOOP;
  END generate_fragments;
END horizontal_miniterm_generator;
/

-- Example usage
DECLARE
  l_predicates horizontal_miniterm_generator.predicate_table;
  l_fragments horizontal_miniterm_generator.fragment_table;
BEGIN
  l_predicates := horizontal_miniterm_generator.predicate_table(
    horizontal_miniterm_generator.predicate_record('R1', 'a, b'),
    horizontal_miniterm_generator.predicate_record('R2', 'c, d'),
    horizontal_miniterm_generator.predicate_record('R3', 'e, f')
  );

  horizontal_miniterm_generator.generate_fragments(p_predicates => l_predicates, o_fragments => l_fragments);

  FOR i IN 1..l_fragments.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(l_fragments(i));
  END LOOP;
END;
/
