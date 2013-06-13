class PowerAssignmentsController < ApplicationController
  # GET /power_assignments
  # GET /power_assignments.json
  def index
    @power_assignments = PowerAssignment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @power_assignments }
    end
  end

  # GET /power_assignments/1
  # GET /power_assignments/1.json
  def show
    @power_assignment = PowerAssignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @power_assignment }
    end
  end

  # GET /power_assignments/new
  # GET /power_assignments/new.json
  def new
    @power_assignment = PowerAssignment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @power_assignment }
    end
  end

  # GET /power_assignments/1/edit
  def edit
    @power_assignment = PowerAssignment.find(params[:id])
  end

  # POST /power_assignments
  # POST /power_assignments.json
  def create
    @power_assignment = PowerAssignment.new(params[:power_assignment])

    respond_to do |format|
      if @power_assignment.save
        format.html { redirect_to @power_assignment, notice: 'Power assignment was successfully created.' }
        format.json { render json: @power_assignment, status: :created, location: @power_assignment }
      else
        format.html { render action: "new" }
        format.json { render json: @power_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /power_assignments/1
  # PUT /power_assignments/1.json
  def update
    @power_assignment = PowerAssignment.find(params[:id])

    respond_to do |format|
      if @power_assignment.update_attributes(params[:power_assignment])
        format.html { redirect_to @power_assignment, notice: 'Power assignment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @power_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /power_assignments/1
  # DELETE /power_assignments/1.json
  def destroy
    @power_assignment = PowerAssignment.find(params[:id])
    @power_assignment.destroy

    respond_to do |format|
      format.html { redirect_to power_assignments_url }
      format.json { head :no_content }
    end
  end
end
