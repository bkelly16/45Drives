def logical():
  logicalList = []
  n = 0
  x = 0
  for i in range(0,6):
    logicalTuple = []
    for j in range(0,2):
      x = n + 2
      logicalTuple.append(x)
      n += 1
    x = n - 1
    logicalTuple.append(x)
    n += 1
    x = n - 3
    logicalTuple.append(x)
    n += 1
    logicalList.append(tuple(logicalTuple))
  return(logicalList)

def practical():
  phyList = []
  logicalList = logical()
  index = 2
  for i in range(0,2):
    temp = logicalList[index]
    logicalList[index] = logicalList[index+2]
    logicalList[index+2] = temp
    index += 1
  for tupleEntry in logicalList:
    for entry in tupleEntry:
      phyList.append(entry)
  return phyList

phyList = practical()
row = 1
slot = 1
numCards = 1
cardName = '9305-24i'
chassisSize = 60

print("# name\t\tfully qualified or base name of device link")
if cardName == '9305-24i':
  while row != 5:
    for a in range(0,24):
      if numCards > 0:
        print("alias "+str(row)+"-"+str(slot)+"\t/dev/disk/by-path/pci-0000:0"+str(numCards)+":00.0-sas-phy"+str(phyList[a])+"-lun-0")
        if a == 23:
          numCards = numCards - 1
      elif numCards == 0:
        print("alias "+str(row)+"-"+str(slot)+"\t/dev/disk/by-path/pci-0000:-sas-phy"+str(phyList[a])+"-lun-0")
      if slot == 15:
        slot = 1
        row += 1
      else:
        slot += 1
      if row == 5:
        print("DONE")
        break
