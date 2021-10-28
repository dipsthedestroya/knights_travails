require 'pry'

class Node
  attr_accessor :children, :data, :parent
  def initialize(data)
    @data = data
    @children = []
    @parent = nil
  end
end

class Tree
  attr_accessor :root
  def initialize(start)
    @root = build_tree(start)
  end

  def build_tree(start)
    root = Node.new(start)
    node = root
    queue = []
    added = []
    queue.push(root)
    added.push(root.data)
    possible_move_increments = [[2,1], [-2,1], [2,-1],
                               [-2,-1]].map{ |increment| increment.permutation.to_a }.flatten(1)
    while(!queue.empty?)
      possible_move_increments.each do |increment|
        new_pos = [start[0] + increment[0], start[1] + increment[1]]
        if new_pos[0].between?(1,8) && new_pos[1].between?(1,8) && !added.include?(new_pos)
          node.children.push(Node.new(new_pos))
          queue.push(node.children[node.children.length - 1])
          added.push(new_pos)
        end
      end
      node.children.each{|child| child.parent = node}
      queue.shift
      node = queue[0]
      start = queue[0].data if queue[0]
    end
    root
  end

  def print_tree
    queue = [(@root)]
    node = @root
    count = 1
    while queue.length > 0
      print "level: #{count} #{queue[0].data} -> #{queue[0].children.map{|child| child.data }}\n"
      queue[0].children.each{|child| queue.push(child)}
      queue.shift
      count += 1
    end
  end

  def path(destination)
    queue = [@root]
    while !queue.empty?
      return trace_path(queue[0]) if queue[0].data == destination
      queue[0].children.each{|child| queue.push(child)}  
      queue.shift
    end
  end

  def trace_path(node)
    path = []
    while node.parent != nil
      path.unshift(node.data)
      node = node.parent
    end
    path.unshift(node.data)
  end

end

def knight_moves(start, dest)
  t = Tree.new(start)
  t.print_tree
  path = t.path(dest)
  count = path.length - 1
  puts "=> You made it in #{count} move(s)! Here's your path: "
  path.each{|square| print "#{square}\n"}
end

knight_moves([1,1], [8,8])