
IMAGES= \
	 ../images/query_opt_filter_basic.svg \
	 ../images/query_opt_filter_basic_pop.svg \
	 ../images/query_opt_filter_basic_ig.svg \
	 ../images/query_opt_filter_complex.svg \
	 ../images/query_opt_filter_complex_ig.svg \
	 ../images/o_dmc_configuration_tree.svg \
	 ../images/marks_dmc_tree.svg \
	 ../images/cow_btree_1.svg \
	 ../images/cow_btree_2.svg \
	 ../images/cow_btree_3.svg \
	 ../images/ansible_1.svg \
	 ../images/ansible_2.svg \
     $(END)


all: $(IMAGES)

../images/%.svg: %.dot
	dot -o $@ -Tsvg $<
