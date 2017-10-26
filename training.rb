require 'json'
listObject = []

class Computer
  @id
  @name = ''
  @time = []

  def initialize obj
    @id = obj["id"]
    @name = obj["name"]
    @time = obj["time"] || []
  end

  def setName name
    @name = name
  end

  def getId
    return @id
  end

  def regis tt
    @time.push(tt)
  end

  def getName
    return @name
  end

  def getRegis
    return @time
  end

  def getThis
    return {"id" => @id, "name" => @name, "time" => @time}
  end

end

begin
  aFile = File.open("traning.json", "r")
  content = aFile.sysread(1000)
  list = JSON.parse(content)
  list.each do |i|
    listObject.push(Computer.new(i))
  end
rescue Exception => e
  File.new("traning.json", "w")
  aFile = File.open("traning.json", "r")
end

def saveFile listOjCom
  a = []
  listOjCom.each do |i|
    a.push(i.getThis)
  end
  rFile = File.open("traning.json", "w")
  rFile.syswrite(a.to_json)
  rFile.close
end

begin
  puts "---------------Menu---------------"
  puts "1: View list"
  puts "2: Add computer"
  puts "3: Edit computer"
  puts "4: Delete computer"
  puts "5: register time"
  puts "6: Report"
  puts "7: Report time"
  puts "-1: Exit"
  print "Type: "
  menu = gets.to_i

  case menu
    when 1
      puts "---------------------------------"
      puts "\t--List computer--"
      puts "|\tid\t|\tname\t\t|"
      puts "|--------------\t|----------------------\t|"
      listObject.each do |i|
        puts "|\t#{i.getId}\t|\t#{i.getName}\t\t|"
      end
      next


    when 2
      puts "---------------------------------"
      puts "--Add computer--"
      print "type id: "
      id = gets.to_s
      print "type name: "
      nameC = gets.to_s
      nameC.gsub!(/[\n]/, '')
      id.gsub!(/[\n]/, '')
      com = Computer.new ({"id" => id, "name" => nameC})
      listObject.push(com)
      saveFile listObject
      puts "Success!"
      next


    when 3
      puts "---------------------------------"
      # @fathers.select {|father| father["age"] > 35 }
      # puts list.select {|i| i["id"] == 'a' return list.index(i)}
      print "type id: "
      f = gets.to_s
      f.gsub!(/[\n]/, '')
      listObject.each do |i|
        if i.getId == f
          print "change to name: "
          name = gets.to_s
          name.gsub!(/[\n]/, '')
          i.setName name
          puts "success! id: #{f}"
          saveFile listObject
          break
        end
      end

      puts "computer not exist!"


    when 4
      puts "---------------------------------"
      print "type id to delete: "
      f = gets.to_s
      f.gsub!(/[\n]/, '')
      d = 0
      listObject.each do |i|
        if i.getId == f
          listObject.delete_at(listObject.index(i))
          d += 1
        end
      end
      saveFile listObject
      if d == 0
        puts "computer not exist!!"
      else
        puts "#{d} deleted computer!"
      end


    when 5
      puts "---------------------------------"
      print "type id computer add reg: "
      f = gets.to_s
      f.gsub!(/[\n]/, '')
      dem = false
      listObject.each do |i|
        if i.getId == f
          dem = true
          print "type name's student register: "
          name = gets.to_s
          name.gsub!(/[\n]/, '')
          print "type time start - time end (yyyy,mm,dd hh:ii-yyyy,mm,dd hh:ii): "
          date = gets.to_s
          date.gsub!(/[\n]/, '')

          arrD = date.split("-")
          dSt = arrD[0].split(' ')
          dEn = arrD[1].split(' ')

          dStd = dSt[0].split(',')
          dSth = dSt[1].split(':')
          dSEnd = dEn[0].split(',')
          dSEnh = dEn[1].split(':')


          timeStart = Time.gm(dStd[0], dStd[1], dStd[2], dSth[0], dSth[1], 00).to_i
          timeEnd = Time.gm(dSEnd[0], dSEnd[1], dSEnd[2], dSEnh[0], dSEnh[1], 00).to_i

          registerCom = i.getRegis
          if registerCom.length > 0
            registerCom.each do |i|
              if( (timeStart >= i["timeStart"].to_i && timeStart <=i["timeEnd"].to_i) || (timeEnd >= i["timeStart"].to_i && timeEnd<= i["timeEnd"].to_i))
                puts "time register exist #{i["name"]} !"
                break
              end
            end
          end

          i.regis ({"name" => name, "timeStart" => timeStart, "timeEnd" => timeEnd})

          saveFile listObject
          puts "success!"
          break
        end
      end
      if !dem
        puts "#{f} not exist"
      end


    when 6
      puts "---------------------------------"
      now = Time.now.to_i

      listObject.each do |i|
        listReg = i.getRegis
        if listReg.length > 0
          listReg.each do |e|
            if (now >= e["timeStart"].to_i && now <= e["timeEnd"].to_i)
              puts "#{i.getName} => #{e["name"]} use"
            end
          end
        else
          puts "#{i.getName} not use"
        end
      end

    when 7
      puts "---------------------------------"
      puts "Report time"
      listObject.each do |i|
        listReg = i.getRegis
        time = 0;
        if listReg.length > 0
          listReg.each do |e|
            time += e["timeEnd"] - e["timeStart"]
          end
        end
        puts "#{i.getName} => #{(time/60)/60} hour"
      end

    else break
  end

end while menu != -1

aFile.close
