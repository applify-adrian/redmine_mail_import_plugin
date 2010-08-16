class EmailAssignmentController < ApplicationController
  unloadable

  before_filter :find_email_assignment, :except => [:new, :index]
  before_filter :find_project
  before_filter :load_users, :except => [:destroy]
    
  def index
  
    if !params[:project_id] then return end
    
    @project_identifier = params[:project_id]
    @project = Project.find(params[:project_id])
    
    @assignments  = EmailAssignment.find_by_sql('SELECT email_assignments.*, CONCAT(users.firstname, \' \', users.lastname) fullname
      FROM email_assignments INNER JOIN users
      ON email_assignments.user_id = users.id
      WHERE project_id = ' + @project[:id].to_s + '
      ORDER BY email_assignments.email ASC')
  end

  def new
  
    if !params[:project_id] then return end
    
    @project = Project.find(params[:project_id])
    
    @email_assignment = EmailAssignment.new(:project => @project)
    if request.post?
      @email_assignment.attributes = params[:email_assignment]
      if @email_assignment.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to :controller => 'email_assignment', :action => 'index', :project_id => @project
      end
    end
  end
  
  def edit
    if request.post?
      params[:email_assignment][:project_id] = @project[:id]
      if @email_assignment.update_attributes(params[:email_assignment])
        flash[:notice] = l(:notice_successful_update)
        redirect_to :action => 'index', :project_id => @project
      end
    end
  end
  
  def destroy
    @email_assignment.destroy
    redirect_to :action => 'index', :project_id => @project
  end
  
  
private

  def find_email_assignment
    @email_assignment = EmailAssignment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def find_project
    @project = Project.find(params[:project_id])
  end
  
  def load_users
    # Get the users that are members in the project
    @users = User.find_by_sql('SELECT users.id, CONCAT(users.firstname, \' \', users.lastname) fullname FROM members INNER JOIN users
      ON members.user_id = users.id
      WHERE project_id = ' + @project[:id].to_s + '
      AND status = 1
      ORDER BY firstname ASC')
  end

end
