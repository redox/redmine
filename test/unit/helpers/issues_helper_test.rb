# Redmine - project management software
# Copyright (C) 2006-2011  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.expand_path('../../../test_helper', __FILE__)

class IssuesHelperTest < ActionView::TestCase
  include ApplicationHelper
  include IssuesHelper

  include ActionDispatch::Assertions::SelectorAssertions
  fixtures :projects, :trackers, :issue_statuses, :issues,
           :enumerations, :users, :issue_categories,
           :projects_trackers,
           :roles,
           :member_roles,
           :members,
           :enabled_modules,
           :workflows

  # Used by assert_select
  def html_document
    HTML::Document.new(@response.body)
  end

  def setup
    super
    set_language_if_valid('en')
    User.current = nil
    @response = ActionController::TestResponse.new
  end

  def controller
    @controller ||= IssuesController.new
  end

  def request
    @request ||= ActionController::TestRequest.new
  end

  def test_issue_heading
    assert_equal "Bug #1", issue_heading(Issue.find(1))
  end

  def test_issues_destroy_confirmation_message_with_one_root_issue
    assert_equal l(:text_issues_destroy_confirmation), issues_destroy_confirmation_message(Issue.find(1))
  end

  def test_issues_destroy_confirmation_message_with_an_arrayt_of_root_issues
    assert_equal l(:text_issues_destroy_confirmation), issues_destroy_confirmation_message(Issue.find([1, 2]))
  end

  def test_issues_destroy_confirmation_message_with_one_parent_issue
    Issue.find(2).update_attribute :parent_issue_id, 1
    assert_equal l(:text_issues_destroy_confirmation) + "\n" + l(:text_issues_destroy_descendants_confirmation, :count => 1),
      issues_destroy_confirmation_message(Issue.find(1))
  end

  def test_issues_destroy_confirmation_message_with_one_parent_issue_and_its_child
    Issue.find(2).update_attribute :parent_issue_id, 1
    assert_equal l(:text_issues_destroy_confirmation), issues_destroy_confirmation_message(Issue.find([1, 2]))
  end

  context "IssuesHelper#show_detail" do
    context "with no_html" do
      should 'show a changing attribute' do
        @detail = JournalDetail.generate!(:property => 'attr', :old_value => '40', :value => '100', :prop_key => 'done_ratio')
        assert_equal "% Done changed from 40 to 100", show_detail(@detail, true)
      end

      should 'show a new attribute' do
        @detail = JournalDetail.generate!(:property => 'attr', :old_value => nil, :value => '100', :prop_key => 'done_ratio')
        assert_equal "% Done set to 100", show_detail(@detail, true)
      end

      should 'show a deleted attribute' do
        @detail = JournalDetail.generate!(:property => 'attr', :old_value => '50', :value => nil, :prop_key => 'done_ratio')
        assert_equal "% Done deleted (50)", show_detail(@detail, true)
      end
    end

    context "with html" do
      should 'show a changing attribute with HTML highlights' do
        @detail = JournalDetail.generate!(:property => 'attr', :old_value => '40', :value => '100', :prop_key => 'done_ratio')
        @response.body = show_detail(@detail, false)

        assert_select 'strong', :text => '% Done'
        assert_select 'i', :text => '40'
        assert_select 'i', :text => '100'
      end

      should 'show a new attribute with HTML highlights' do
        @detail = JournalDetail.generate!(:property => 'attr', :old_value => nil, :value => '100', :prop_key => 'done_ratio')
        @response.body = show_detail(@detail, false)

        assert_select 'strong', :text => '% Done'
        assert_select 'i', :text => '100'
      end

      should 'show a deleted attribute with HTML highlights' do
        @detail = JournalDetail.generate!(:property => 'attr', :old_value => '50', :value => nil, :prop_key => 'done_ratio')
        @response.body = show_detail(@detail, false)

        assert_select 'strong', :text => '% Done'
        assert_select 'strike' do
          assert_select 'i', :text => '50'
        end
      end
    end

    context "with a start_date attribute" do
      should "format the current date" do
        @detail = JournalDetail.generate!(:property => 'attr', :old_value => '2010-01-01', :value => '2010-01-31', :prop_key => 'start_date')
        assert_match "01/31/2010", show_detail(@detail, true)
      end

      should "format the old date" do
        @detail = JournalDetail.generate!(:property => 'attr', :old_value => '2010-01-01', :value => '2010-01-31', :prop_key => 'start_date')
        assert_match "01/01/2010", show_detail(@detail, true)
      end
    end

    context "with a due_date attribute" do
      should "format the current date" do
        @detail = JournalDetail.generate!(:property => 'attr', :old_value => '2010-01-01', :value => '2010-01-31', :prop_key => 'due_date')
        assert_match "01/31/2010", show_detail(@detail, true)
      end

      should "format the old date" do
        @detail = JournalDetail.generate!(:property => 'attr', :old_value => '2010-01-01', :value => '2010-01-31', :prop_key => 'due_date')
        assert_match "01/01/2010", show_detail(@detail, true)
      end
    end

    context "with a project attribute" do
      should_show_the_old_and_new_values_for('project_id', Project)
    end

    context "with a issue status attribute" do
      should_show_the_old_and_new_values_for('status_id', IssueStatus)
    end

    context "with a tracker attribute" do
      should_show_the_old_and_new_values_for('tracker_id', Tracker)
    end

    context "with a assigned to attribute" do
      should_show_the_old_and_new_values_for('assigned_to_id', User)
    end

    context "with a priority attribute" do
      should_show_the_old_and_new_values_for('priority_id', IssuePriority) do
        @old_value = IssuePriority.generate!(:type => 'IssuePriority')
        @new_value = IssuePriority.generate!(:type => 'IssuePriority')
      end
    end

    context "with a category attribute" do
      should_show_the_old_and_new_values_for('category_id', IssueCategory)
    end

    context "with a fixed version attribute" do
      should_show_the_old_and_new_values_for('fixed_version_id', Version)
    end

    context "with a estimated hours attribute" do
      should "format the time into two decimal places"
      should "format the old time into two decimal places"
    end

    should "test custom fields"
    should "test attachments"

  end

end
