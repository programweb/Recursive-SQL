use ghdx;
WITH RECURSIVE q AS (

	SELECT ttd.tid,
		COALESCE(tth_parent.parent, 0) as parent,
		ttd.vid,
		ttd.name,
        s.field_synonyms_value,
		s.field_synonyms_format,
        n.field_notes_value,
		n.field_notes_format
	FROM taxonomy_term_data ttd
    LEFT JOIN taxonomy_term_hierarchy tth_parent ON ttd.tid = tth_parent.tid
    LEFT JOIN field_data_field_synonyms s ON ttd.tid = s.entity_id
    LEFT JOIN field_data_field_notes n ON ttd.tid = n.entity_id
    WHERE ttd.tid = @child

	UNION ALL

	SELECT ttd2.tid, COALESCE(tth_parent2.parent, 0), q.vid, q.name,
		q.field_synonyms_value, q.field_synonyms_format,
        q.field_notes_value, q.field_notes_format
	FROM taxonomy_term_data ttd2
    LEFT JOIN taxonomy_term_hierarchy tth_parent2 ON ttd2.tid = tth_parent2.tid
	JOIN q
	ON ttd2.tid = q.parent

)
SELECT	@child := 781 as child,
		group_concat(tid separator ',') AS parent_to_anscestors,
        vid,
        name,
        field_synonyms_value,
        field_synonyms_format,
        field_notes_value,
        field_notes_format
FROM q
WHERE tid <> @child ;
