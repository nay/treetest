require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do
  describe "attributes=" do
    it "should accept parent_id" do
      Category.new(:parent_id => 3).parent_id.should == 3
    end
  end

  describe "parent_id=" do
    it "should accept parent_id" do
      c = Category.new
      c.parent_id = 17
      c.parent_id.should == 17
    end
  end

  describe "create" do
    it "should be saved as a root." do
      c = Category.new(:name => "food")
      c.save.should be_true
    end
    describe "under the root" do
      before do
        Category.create!(:name => "food")
        @food = Category.find_by_name("food")
      end

      it "should be saved as a child of the root." do
        c = Category.new(:name => "cake", :parent_id => @food.id)
        c.save.should be_true
        @food.reload
        c.parent.should == @food
        c.lft.should > @food.lft
        c.rgt.should < @food.rgt
      end

      it "should be saved as a second root." do
        c = Category.new(:name => "cake", :parent_id => nil)
        c.save.should be_true
        @food.reload
        c.parent.should be_nil
        c.lft.should > @food.lft
        c.rgt.should > @food.rgt
      end
    end

    describe "move an element in the tree" do
      before do
        Category.create!(:name => "food")
        @food = Category.find_by_name("food")
        Category.create!(:name => "water", :parent_id => @food.id)
        @water = Category.find_by_name("water")
        @food.reload
        raise "@water should be a child of @food" unless @water.parent == @food
      end
      
      it "can be moved from food to root." do
        @water.parent_id = nil
        @water.save!
        @water.parent.should be_nil
        @food.reload
        @water.lft.should > @food.lft
        @water.rgt.should > @food.rgt
        @food.children.should be_empty
      end

      it "can be a child of another parent." do
        Category.create!(:name => "beverage")
        @beverage = Category.find_by_name("beverage")
        @water.reload
        @water.parent_id = @beverage.id
        @water.save!

        @beverage.reload
        @food.reload
        @water.parent.should == @beverage
        @water.lft.should > @beverage.lft
        @water.rgt < @beverage.rgt
        @water.rgt > @food.rgt
        @food.children.should be_empty
        @food.descendants.include?(@beverage).should be_false
      end

      it "should not be a child of itself" do
        @water.parent_id = @water.id
        lambda {@water.save!}.should raise_error(ActiveRecord::ActiveRecordError)
      end

      it "should not be a child of its child" do
        @food.parent_id = @water.id
        lambda {@food.save!}.should raise_error(ActiveRecord::ActiveRecordError)
      end
    end

  end
end
