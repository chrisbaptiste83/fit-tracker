require "test_helper"

class ProgressControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in(@user)
  end

  test "redirects to login when not authenticated" do
    sign_out
    get progress_index_path
    assert_redirected_to new_session_path
  end

  # GET /progress

  test "GET index returns success" do
    get progress_index_path
    assert_response :success
  end

  # GET /progress/:id

  test "GET show returns success for own progress log" do
    get progress_path(progress_logs(:log_week1))
    assert_response :success
  end

  test "GET show returns 404 for another user's progress log" do
    get progress_path(progress_logs(:other_user_log))
    assert_response :not_found
  end

  # GET /progress/new

  test "GET new returns success" do
    get new_progress_path
    assert_response :success
  end

  # POST /progress

  test "POST create with valid params creates progress log" do
    assert_difference "ProgressLog.count", 1 do
      post progress_index_path, params: {
        progress_log: { date: 10.days.ago.to_date, weight: 79.5 }
      }
    end
    assert_redirected_to progress_index_path
  end

  test "POST create assigns log to current user" do
    post progress_index_path, params: {
      progress_log: { date: 11.days.ago.to_date, weight: 79.0 }
    }
    assert_equal @user, ProgressLog.last.user
  end

  test "POST create with missing date renders new" do
    assert_no_difference "ProgressLog.count" do
      post progress_index_path, params: {
        progress_log: { weight: 80.0 }
      }
    end
    assert_response :unprocessable_entity
  end

  test "POST create with duplicate date for user renders new" do
    assert_no_difference "ProgressLog.count" do
      post progress_index_path, params: {
        progress_log: { date: progress_logs(:log_week1).date, weight: 82.0 }
      }
    end
    assert_response :unprocessable_entity
  end

  # PATCH /progress/:id

  test "PATCH update with valid params updates progress log" do
    patch progress_path(progress_logs(:log_week2)), params: {
      progress_log: { notes: "Updated note" }
    }
    assert_redirected_to progress_index_path
    assert_equal "Updated note", progress_logs(:log_week2).reload.notes
  end

  test "PATCH update returns 404 for another user's log" do
    patch progress_path(progress_logs(:other_user_log)), params: {
      progress_log: { notes: "Hacked" }
    }
    assert_response :not_found
  end

  # DELETE /progress/:id

  test "DELETE destroy removes the progress log" do
    assert_difference "ProgressLog.count", -1 do
      delete progress_path(progress_logs(:log_week1))
    end
    assert_redirected_to progress_index_path
  end

  test "DELETE destroy returns 404 for another user's log" do
    delete progress_path(progress_logs(:other_user_log))
    assert_response :not_found
  end
end
