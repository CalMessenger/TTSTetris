
--i j l o s z t is tetrimino order
modelNumber = 7
scoreTitle = 'Score:'
score = 0
modelGUIDS = {'976064','c33277','acca5c','30437b','7ab303','73262e','50ddeb'; n = modelNumber}
blockGUID = 'aca52d'
modelTypeCoords =
{
  {--i
    {{-1,0},{1,0},{2,0}},--0
    {{0,-2},{0,-1},{0,1}},--90
    {{-2,0},{-1,0},{1,0}},--180
    {{0,-1},{0,1},{0,2}},--270
  },
  {--j
    {{-1,0},{-1,1},{1,0}},--0
    {{0,-1},{0,1},{1,1}},--90
    {{-1,0},{1,-1},{1,0}},--180
    {{-1,-1},{0,-1},{0,1}},--270
  },
  {--l
    {{-1,0},{1,0},{1,1}},--0
    {{0,-1},{0,1},{1,-1}},--90
    {{-1,-1},{-1,0},{1,0}},--180
    {{-1,1},{0,-1},{0,1}},--270
  },
  {--o
    {{0,1},{1,0},{1,1}},--0
    {{0,-1},{1,-1},{1,0}},--90
    {{-1,-1},{-1,0},{0,-1}},--180
    {{-1,-1},{-1,1},{0,1}},--270
  },
  {--s
    {{-1,-1},{0,-1},{1,0}},--0
    {{-1,0},{-1,1},{0,-1}},--90
    {{-1,0},{0,1},{1,1}},--180
    {{0,1},{1,0},{1,-1}},--270
  },
  {--z
    {{-1,1},{0,1},{1,0}},--0
    {{0,-1},{1,0},{1,1}},--90
    {{-1,0},{0,-1},{1,-1}},--180
    {{-1,-1},{-1,0},{0,1}},--270
  },
  {--t
    {{-1,0},{0,1},{1,0}},--0
    {{0,-1},{0,1},{1,0}},--90
    {{-1,0},{0,-1},{1,0}},--180
    {{-1,0},{0,-1},{0,1}},--270
  }
  ;n = modelNumber
}
modelTypes = {n = modelNumber}

model = {n = modelNumber}
modelRotation = 1
modelPrevPos = {}
modelPreviousCoords = {}
modelCoords = {n = 2}
disassembledCubes = {}


rotationSystems = {NINTENDO = 1}
levelSystems = {NES = 1}
wallKicks = false
hardDrops = false
lockDelay = false

modeSettings = 
{--NES
  {NES = 
    {ROTATIONS = rotationSystems.NINTENDO},
    {WALLKICKS = false},
    {HARDDROPS = false},
    {LOCKDELAY = false},
    {LEVELS = levelSystems.NES}

  }

}

gridBorderX = 12
gridBorderY = 22

grid = {}

start = false

dropTime = 1
dropTimer = 0

downLocked = false
downTime = 2
downTimer = 0

function onLoad()
  SetKeyBindings()
   for i,v in ipairs(modelGUIDS) do
      modelTypes[i] = getObjectFromGUID(v)
   end
   block = getObjectFromGUID(blockGUID)
   for i=1,gridBorderX do
     grid[i] = {}
     for j=1,gridBorderY do
       grid[i][j] = {n = 2}
       if i == 1 or i == gridBorderX or j == 1 or j == gridBorderY then
         grid[i][j][1] = true
       else
         grid[i][j][1] = false
       end
     end
   end
   math.randomseed(os.time())
   SetupText()
end

function onUpdate()
  if start == true then
    Countdown()
  end
  console.update() 
  
end

function UpdateScore(newScore)
    if score ~= newScore then
      score = newScore
      UpdateText(score)
    end
end

function SetupText()
  UpdateText(score)
  self.UI.setAttribute('Score','fontStyle','Bold')
  self.UI.setAttribute('Score','fontSize','50')
  self.UI.setAttribute('Score','color','Grey')
  self.UI.setAttribute('Score','alignment','LowerCenter')
  self.UI.setAttribute('Score','outline','Black')
  self.UI.setAttribute('Score','outlineSize',"-1 -1")
end

function UpdateText(score)
    scoreText = scoreTitle
    scoreText = scoreText ..tostring(score)
    self.UI.setAttribute('Score','text',scoreText)
end

function SetKeyBindings()
  addHotkey('Move Left',function()MoveLeft()end,false)
  addHotkey('Move Right',function()MoveRight()end,false)
  addHotkey('Move Down',function()InputDown()end,false)
  addHotkey('Rotate',function()RotateRight()end,false)
end

function SpawnModel()
  modelType = math.random(1,modelNumber)
  model = modelTypes[modelType].clone()
end

function onObjectSpawn(modelInput)
    if modelInput == model then
        model.setLock(true)
        model.setPosition(Vector(-1,4,17))
        modelCoords = vector(6,20,0)
        modelRotation = 1
        rotation = 0
    end
end

--Game State--

function DropCountdown()
  dropTimer = dropTimer + Time.delta_time
  if dropTimer > dropTime then
      MoveDown(false)
      dropTimer = 0
  end
end

function DownCountdown()
  dropTimer = dropTimer + Time.delta_time
  if dropTimer > dropTime then
      MoveDown(false)
      dropTimer = 0
  end
end

function StartGame()
  start = true
  SpawnModel()
end

function PauseGame()
end

--Clear the grid and remove model
function EndGame()
  start = false
  for j = 2,21 do
    for i = 2,11 do
      if grid[i][j][1] == true then
        SetGrid(i,j,false,nil, true)
      end
    end
  end
  model.destruct()
  UpdateScore(0)
end

--Model Movement--

function RotateRight()
  rotation = model.getRotation().y
  rotation = rotation + 90
  modelRotation = modelRotation + 1
  if modelRotation > 4 then
    rotation = 0
    modelRotation = 1
  end
  model.setRotation(Vector(0,rotation, 0))
end

function MoveLeft()
  modelPrevPos = model.getPosition()
  modelPrevCoords = modelCoords;

  if CheckCollision(vector(modelCoords.x - 1,modelCoords.y,modelCoords.z)) == false then
    model.setPosition(vector(modelPrevPos.x - 2,modelPrevPos.y, modelPrevPos.z))
    modelCoords.x = modelCoords.x - 1
  end
end

function MoveRight()
  modelPrevPos = model.getPosition()
  modelPrevCoords = modelCoords;

  if CheckCollision(vector(modelCoords.x + 1,modelCoords.y,modelCoords.z)) == false then
    model.setPosition(vector(modelPrevPos.x + 2,modelPrevPos.y, modelPrevPos.z))
    modelCoords.x = modelCoords.x + 1
  end
end

function InputDown()
  MoveDown(true)
end

function CountDownDown()

end

function MoveDown(fromInput)
  modelPrevPos = model.getPosition()
  modelPrevCoords = modelCoords;

  if CheckCollision(vector(modelCoords.x,modelCoords.y - 1,modelCoords.z)) == false then
    model.setPosition(vector(modelPrevPos.x,modelPrevPos.y, modelPrevPos.z - 2))
    modelCoords.y = modelCoords.y - 1
  else
    AddModelToGrid()
    SpawnModel()
  end

  if fromInput == true then
    UpdateScore(score + 1)
  end
end

-- Line Calculus--

--Check if line is complete and ready for line clear
function LineCheck(numLines)
  lineComplete = true
  for j = 2,21 do
    for i = 2,11 do
      if grid[i][j][1] == false then
          lineComplete = false
      end
    end
    if lineComplete == true then
      DestroyLine(j)
      LineCheck(numLines + 1)
      return
    end
    lineComplete = true
  end
  CalculateLineScore(numLines)
end

function CalculateLineScore(numLines)
  if numLines == 1 then
    UpdateScore(score + 40)
  elseif numLines == 2 then
    UpdateScore(score + 100)
  elseif numLines == 3 then
    UpdateScore(score + 300)
  elseif numLines == 4 then
    UpdateScore(score + 1200)
  end
end

--Used for line clears - wipe out all cubes on line, then pull upper lines down
function DestroyLine(line)
  for i = 2, 11 do
    SetGrid(i, line, false, nil, true)
  end
  for j = line, 20 do
    for i = 2, 11 do--Move block from above row down
      if grid[i][j+1][1] == true then
        SetGrid(i,j,true,grid[i][j+1][2], false)
        SetGrid(i,j + 1,false, nil, false)

          blockPos = grid[i][j][2].getPosition()
          grid[i][j][2].setPosition(vector(blockPos.x,blockPos.y,blockPos.z - 2))
      end
    end
  end
end

--Disassemble model into child cubes, then add them to the grid 
function AddModelToGrid()
    DisassembleModel()
    for i= 1,Length(disassembledCubes) do 
        --work out grid position based on position relative to pivot square
        xDistance = math.abs((disassembledCubes[i].getPosition().x - model.getPosition().x )) / 2
        yDistance = math.abs((disassembledCubes[i].getPosition().z - model.getPosition().z )) / 2

        xMultiplier = 1
        yMultiplier = 1

        if disassembledCubes[i].getPosition().x < model.getPosition().x then
          xMultiplier = -1
        end
        if disassembledCubes[i].getPosition().z < model.getPosition().z then
          yMultiplier = -1
        end

        disassembledCubes[i].setLock(true)
        xCoord = math.floor(modelCoords.x + (xDistance * xMultiplier) + 0.5)
        yCoord = math.floor(modelCoords.y + (yDistance * yMultiplier) + 0.5)

        SetGrid(xCoord,yCoord,true,disassembledCubes[i], false)
    end
    for i,v in pairs (disassembledCubes) do
      disassembledCubes[i] = nil
    end
    LineCheck(0)--check for any line clears
end

--Helper funcs--

--Sets a position in the grid to either true or false, meaning a square is or isnt present
function SetGrid(x,y,present,cube, destruct)
    grid[x][y][1] = present
    if present == false then
        if grid[x][y][2] ~= nil and destruct == true then
            grid[x][y][2].destruct()
        end
        grid[x][y][2] = nil
    else
        grid[x][y][2] = cube
    end

end

--Outputs the length of a table
function Length(table)
  length = 0
  for i in pairs(table) do
    length = length + 1
  end
  return length
end

--Removes all connections of a model and adds all children to disassembledCubes
function DisassembleModel()
  cubeRefs = model.removeAttachments()
  table.insert(disassembledCubes,model)
  for i = 1, Length(cubeRefs) do
      cubeRefs2 = cubeRefs[i].removeAttachments()
      table.insert(disassembledCubes,cubeRefs[i])
      for j = 1, Length(cubeRefs2) do
          cubeRefs3 = cubeRefs2[j].removeAttachments()
          table.insert(disassembledCubes,cubeRefs2[j])
          for k = 1, Length(cubeRefs3) do
              table.insert(disassembledCubes,cubeRefs3[k])
          end
      end
  end
end

--If any of the models children are hitting an existing grid square
function CheckCollision(newCoords)
  for i,v in ipairs(modelTypeCoords[modelType][modelRotation]) do --if any of the child blocks of pivot are colliding
      if grid[newCoords.x + v[1]][newCoords.y + v[2]][1] == true then
        return true
      end
  end
  if grid[newCoords.x][newCoords.y][1] == true then--if pivot is colliding
    return true
  end
  return false
end





