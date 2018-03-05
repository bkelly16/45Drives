import subprocess, time
starttime = time.time()

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

def countCards():
  call = subprocess.Popen('lspci | grep SAS', shell=True, stdout=subprocess.PIPE).stdout
  outputLines = call.read().splitlines()
  numCards = len(outputLines)
  return numCards
def differentiateCards():
  cards = []
  numCards = countCards()
  for i in range(numCards):
    boardNameLine = subprocess.Popen("sas3flash -c %d -list | grep 'Board Name'"%i, shell=True, stdout=subprocess.PIPE).stdout
    boardNameLine2 = boardNameLine.read().splitlines()
    try:
      boardName = boardNameLine2[0].split()[3]
    except IndexError:
      inte = 0
    if boardName == 'SAS9305-16i':
      cards.append('16i')
    if boardName == 'SAS9305-24i':
      cards.append('24i')
  return cards


cardList = differentiateCards()
phyList = practical()
row = 1
slot = 1
numCards = countCards()
cardName = '9305-24i'
chassisSize = 60
controllerNumber = 0

f = open("/etc/zfs/vdev_id.conf","w+")

f.write("# by-vdev\n")
f.write("# name\t\tfully qualified or base name of device link\n")
for entry in cardList:

  if entry == '24i':
    pciAddress = (subprocess.Popen("sas3flash -c %d -list | grep 'PCI Address'"%controllerNumber, shell=True, stdout=subprocess.PIPE).stdout).read().splitlines()[0].split()[3]
    pciAddress = pciAddress[3]+pciAddress[4]
    controllerNumber += 1
    while row != 5:
      for a in range(0,24):
        if numCards > 0:
          f.write("alias "+str(row)+"-"+str(slot)+"\t/dev/disk/by-path/pci-0000:"+pciAddress+":00.0-sas-phy"+str(phyList[a])+"-lun-0\n")   
          if slot == 15:
            slot = 1
            row += 1
          else:
            slot += 1    
      break

          
          

  if entry == '16i':
    pciAddress = (subprocess.Popen("sas3flash -c %d -list | grep 'PCI Address'"%controllerNumber, shell=True, stdout=subprocess.PIPE).stdout).read().splitlines()[0].split()[3]
    pciAddress = pciAddress[3]+pciAddress[4]
    controllerNumber += 1
    while row != 5:
      for b in range(0,16):
        if numCards > 0:
          f.write("alias "+str(row)+"-"+str(slot)+"\t/dev/disk/by-path/pci-0000:"+pciAddress+":00.0-sas-phy"+str(phyList[a])+"-lun-0\n")
          if slot == 15:
            slot = 1
            row += 1
          else:
            slot += 1
      break
       
while row < 5:
  f.write("alias "+str(row)+"-"+str(slot)+"\t/dev/disk/by-path/pci-0000:-sas-phy"+str(phyList[a])+"-lun-0\n")
  if slot == 15:
    slot = 1
    row += 1
  else:
    slot += 1    
endtime = time.time()
print "Done!"
