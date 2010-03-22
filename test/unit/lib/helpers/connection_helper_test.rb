# WontoMedia - a wontology web application
# Copyright (C) 2010 - Glen E. Ivey
#    www.wontology.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version
# 3 as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program in the file COPYING and/or LICENSE.  If not,
# see <http://www.gnu.org/licenses/>.


require 'test_helper'

class ConnectionHelperTest < ActiveSupport::TestCase

  # desired sort order for connections with item as subject:
  #   built-in predicates below others
  #    value objects above item objects
  #    [blank objs where predicate has_scalar_object count as 'value']
  #     properties with lower maximums above others
  #      properties with more instances in list above those w/ fewer
  #      (extra parameter allows this, may actually reflect other factor)
  #       property ID order
  #################################################### pred's ==
  #        filled-in objects above missing objects
  #         built-in objects below others
  # compare(a, b, rankings_hash)
  test "connection compare_builtin preds" do
    assert ConnectionHelper.compare(
      connections(:sortable_with_builtin_pred),
      connections(:sortable_with_contributor_pred_builtin_obj) ) > 0
    assert ConnectionHelper.compare(
      connections(:sortable_with_contributor_pred_builtin_obj),
      connections(:sortable_with_builtin_pred) ) < 0
    assert ConnectionHelper.compare(
      connections(:sortable_with_builtin_pred),
      connections(:sortable_with_builtin_pred) ) == 0
  end

  test "connection compare_objs value vs item" do
    item_obj = connections(:sortable_with_contributor_pred_and_obj)
    value_obj = connections(:sortable_with_contributor_pred_value_obj)

    # connections with filled-in value objects
    assert ConnectionHelper.compare( item_obj, value_obj ) > 0
    assert ConnectionHelper.compare( value_obj, item_obj ) < 0
    assert ConnectionHelper.compare( value_obj, value_obj ) == 0

    # connections with "blank" value objects
    blank_obj = make_con_with_blank_obj( items(:testValueProperty) )
    assert ConnectionHelper.compare( item_obj, blank_obj ) > 0
    assert ConnectionHelper.compare( blank_obj, item_obj ) < 0
    assert ConnectionHelper.compare( blank_obj, blank_obj ) == 0
  end

  # sortable_sortX sortPropertyX
  # sortable_sort1 sortProperty1  (sortPropery1 max_uses_per_item '1')
  # sortable_sort4 sortProperty4  (sortPropery1 max_uses_per_item '4')
  test "connection compare_property maximums" do
    assert ConnectionHelper.compare(
      connections(:sortable_sortX), connections(:sortable_sort1) ) > 0
    assert ConnectionHelper.compare(
      connections(:sortable_sort1), connections(:sortable_sortX) ) < 0

    assert ConnectionHelper.compare(
      connections(:sortable_sort4), connections(:sortable_sort1) ) > 0
    assert ConnectionHelper.compare(
      connections(:sortable_sort1), connections(:sortable_sort4) ) < 0

    assert ConnectionHelper.compare(
      connections(:sortable_sort4), connections(:sortable_sort4) ) == 0
    assert ConnectionHelper.compare(
      connections(:sortable_sort1), connections(:sortable_sort1) ) == 0
  end

  # we're going to build a synthetic hash, rather than actually counting
  test "connection compare_properties by factor hash" do
    sort_x = connections(:sortable_sortX)
    sort_y = connections(:sortable_sortY)
    factor_hash = {}

    factor_hash[sort_x.predicate_id] = 2   # sort_y ~= 0
    assert ConnectionHelper.compare( sort_x, sort_y, factor_hash ) < 0
    assert ConnectionHelper.compare( sort_x, sort_x, factor_hash ) == 0
    assert ConnectionHelper.compare( sort_y, sort_x, factor_hash ) > 0
    assert ConnectionHelper.compare( sort_y, sort_y, factor_hash ) == 0

    factor_hash[sort_y.predicate_id] = 4
    assert ConnectionHelper.compare( sort_x, sort_y, factor_hash ) > 0
    assert ConnectionHelper.compare( sort_y, sort_x, factor_hash ) < 0
    assert ConnectionHelper.compare( sort_y, sort_y, factor_hash ) == 0

    factor_hash[sort_x.predicate_id] = 6
    assert ConnectionHelper.compare( sort_x, sort_y, factor_hash ) < 0
    assert ConnectionHelper.compare( sort_y, sort_x, factor_hash ) > 0
    assert ConnectionHelper.compare( sort_x, sort_x, factor_hash ) == 0
  end

  test "connection compare_property id" do
    # db IDs assigned in fixtures seems stable, though random.  Tests assume
    #   items(:sortPropertyX).id > items(:sortPropertyY).id

    sort_x = connections(:sortable_sortX)
    sort_y = connections(:sortable_sortY)
    assert ConnectionHelper.compare( sort_x, sort_y ) > 0
    assert ConnectionHelper.compare( sort_y, sort_x ) < 0
  end

  test "connection compare_blank objs" do
    con_with_blank_obj = make_con_with_blank_obj( items(:testProperty) )

    sortable_cpo = connections(:sortable_with_contributor_pred_and_obj)
    assert ConnectionHelper.compare( con_with_blank_obj, sortable_cpo ) > 0
    assert ConnectionHelper.compare( sortable_cpo, con_with_blank_obj ) < 0
    assert ConnectionHelper.compare(
      con_with_blank_obj, con_with_blank_obj ) == 0
  end

  test "connection compare_builtin objs" do
    assert ConnectionHelper.compare(
      connections(:sortable_with_contributor_pred_and_obj),
      connections(:sortable_with_contributor_pred_builtin_obj) ) < 0
    assert ConnectionHelper.compare(
      connections(:sortable_with_contributor_pred_builtin_obj),
      connections(:sortable_with_contributor_pred_and_obj) ) > 0
    assert ConnectionHelper.compare(
      connections(:sortable_with_contributor_pred_and_obj),
      connections(:sortable_with_contributor_pred_and_obj) ) == 0
  end



  test "test sorting with connection compare" do
    tP_with_blank_obj = make_con_with_blank_obj( items(:testProperty) )
    tVP_with_blank_obj = make_con_with_blank_obj( items(:testValueProperty) )

    unsorted_array = [
      tVP_with_blank_obj,
      tP_with_blank_obj,
      connections(:sortable_with_contributor_pred_and_obj),
      connections(:sortable_sortX),
      connections(:sortable_sort4),
      connections(:sortable_with_builtin_pred),
      connections(:sortable_sort1),
      connections(:sortable_sortY),
      connections(:sortable_with_contributor_pred_builtin_obj),
      connections(:sortable_with_contributor_pred_value_obj),
      connections(:sortable_sortX3),
    ]
    expected_array = [
      connections(:sortable_with_contributor_pred_value_obj),
      tVP_with_blank_obj,
      connections(:sortable_sort1),
      connections(:sortable_sort4),
      connections(:sortable_sortY),
      connections(:sortable_with_contributor_pred_and_obj),
      connections(:sortable_with_contributor_pred_builtin_obj),
      tP_with_blank_obj,
      connections(:sortable_sortX),
      connections(:sortable_sortX3),
      connections(:sortable_with_builtin_pred),
    ]

    pred_use_count_hash = {}
    unsorted_array.each do |connection|
      if pred_use_count_hash[connection.predicate_id].nil?
        pred_use_count_hash[connection.predicate_id] = 0
      end
      pred_use_count_hash[connection.predicate_id] += 1
    end
    pred_use_count_hash[connections(:sortable_sortY).predicate_id] += 4

    assert expected_array == unsorted_array.sort { |a, b|
      ConnectionHelper.compare( a, b, pred_use_count_hash ) }
  end

private

  def make_con_with_blank_obj(predicate)
    # violates validations, so can't have in fixtures
    Connection.new({
      :subject_id => items(:sortItem1).id,
      :predicate_id => predicate.id  })
  end
end
