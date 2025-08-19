from matplotlib import pyplot as plt
import numpy as np
data = {"Self-Hosted 0": [158,13,5,4,54,58,60,60,59,62,62,63,62,63,59,60,61,63,61,60,62,60,61,60,57,60,56,60,60,61,62,60,60,60,61,61,59,58,62,60,59,59,59,58,59,56,60,59,59,57,58,59,58,55,53,52,53,51,49,48,46,45,45,45,44,42,43,44,43,42,40,41,42,39,42,43,42,40,39,38,37,36,37,37,38,40,39,40,39,39,40,40,38,38,39,35,37,35,33,33,33,33,35,32,33,31,31,31,30,31,31,32,32,32,32,32,31,33,32,32,33,32,33,32,33,31,32,33,33,33,33,32,33,34,35,36,34,34,33,36,37,36,36,37,35,35,34,35,34,37,38,38,37,36,36,36,37,38,39,37,36,38,38,38,39,38,37,37,38,37,38,37,38,38,42,42,39,39,41,43],
    "Self-Hosted 1": [22,10,57,56,57,59,57,60,59,60,59,59,61,60,61,58,59,59,59,58,59,59,58,58,59,60,59,59,50,59,60,58,59,57,58,58,58,59,58,59,59,59,59,57,60,60,59,58,59,59,59,57,58,60,60,57,56,56,52,50,48,48,47,46,45,44,44,44,43,42,42,41,41,39,38,36,35,36,37,37,36,37,37,37,36,36,35,35,35,36,36,34,33,32,30,31,30,30,30,29,31,31,31,31,29,30,31,32,32,32,32,32,31,33,31,32,33,33,33,32,32,32,33,32,33,32,32,32,32,32,33,34,32,32,33,33,33,33,33,31,33,33,33,34,32,32,34,33,32,34,34,33,34,34,35,35,34,36,36,38,40,39,38,37,37,37,37,37,36,37,35,37,38,37,37,38,38,43,43,43],
    "Self-Hosted 2": [22,10,36,51,53,54,54,55,54,58,55,56,55,56,57,56,55,57,55,56,56,56,55,55,56,57,56,57,55,58,58,59,58,57,58,58,57,58,57,56,58,57,58,59,57,58,57,58,57,56,58,57,57,56,55,58,56,57,55,56,57,56,57,56,55,55,55,54,53,54,53,53,50,47,45,46,44,44,44,44,44,44,44,40,38,36,31,29,30,29,30,30,30,30,31,31,31,31,31,31,31,30,32,30,29,30,29,29,29,29,29,29,31,31,33,32,33,32,31,31,31,30,33,33,32,31,31,32,32,33,32,33,33,34,35,35,35,34,32,31,32,32,31,34,37,37,37,34,34,33,33,34,33,35,35,35,36,37,36,38,38,38,39,38,39,38,38,39,39,39,38,40,37,38,41,42,42,42,45,43],
    "Client 0": [32,92,43,61,55,72,65,71,67,68,65,67,60,66,66,64,66,66,69,69,68,66,66,66,66,65,66,65,66,68,66,68,66,68,67,65,65,67,65,64,63,67,66,64,65,62,63,66,65,67,63,65,64,66,64,61,64,62,63,64,62,62,65,63,63,62,65,61,58,59,52,52,55,55,51,52,49,48,43,44,43,48,51,50,51,52,53,51,52,50,48,45,44,46,47,46,47,39,38,36,36,37,35,32,32,32,31,32,31,31,30,30,31,30,31,30,30,30,31,30,30,31,30,31,32,31,31,32,31,32,33,33,33,36,37,39,39,38,38,38,36,37,38,38,37,42,43,42,38,38,38,37,37,38,38,38,38,39,38,37,41,40,40,41,39,39,38,41,41,40,41,46,48,45,45,43,41,42,43,42,43,42,41,41,40,40,39,39,41,41,41],
    "Client 1": [37,60,41,47,59,59,58,57,53,57,55,59,55,57,56,58,58,60,60,58,59,61,61,61,60,60,59,62,60,63,62,63,63,65,64,65,62,61,65,63,63,63,62,58,57,62,60,56,65,61,63,64,56,65,63,63,64,63,63,63,63,64,64,62,63,63,63,65,64,64,65,65,64,63,62,60,63,62,57,58,55,54,49,53,52,50,49,52,38,36,37,36,37,37,38,36,37,37,35,36,38,38,36,36,35,35,36,37,35,34,32,33,33,33,34,33,33,33,32,31,32,34,34,35,35,35,34,34,34,33,33,34,34,34,34,34,34,35,35,35,35,35,34,35,33,32,32,33,34,33,35,35,35,35,34,34,34,35,36,36,35,37,36,37,36,36,38,37,38,38,37,37,35,37,38,38,38,40,40,39,40,39,40,45,43,42,42,39,38,37,36],
}

for trial in data.keys():
    mean = np.mean(data[trial])
    median = np.median(data[trial])
    line, = plt.plot(data[trial], label=trial)
    plt.axhline(mean, color = line.get_color())
    plt.axhline(median, color = line.get_color(), linestyle = ':')
plt.legend()
plt.show()
metadata = {"Mods":
"""20:59:40 ============================================================================================= List of mods ===============================================================================================
20:59:40 modsReadOnly = true
20:59:40 safeModsActivated = false
20:59:40 customMods = true
20:59:40 hash = '224A1DF2EDB6AFE74CB8040267739EC2118777E6'
20:59:40 hashShort = '2e460869'
20:59:40                                               name |               modDir |    default |   official |               origin |                                     hash | hashShort | fullPath
20:59:40 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
20:59:40                            @Blastcore Murr Edition | @Blastcore Murr Edition |      false |      false |             GAME DIR | 874166cd6f15f09a81be820779b3f43d34c3d814 |  cf25e21a | C:\Spiele\Steam\steamapps\common\Arma 3\!Workshop\@Blastcore Murr Edition
20:59:40                                   Photon VFX Smoke |  @Photon VFX - Smoke |      false |      false |             GAME DIR | d32c6143289d9025f066ab83060decfb5a52e5a8 |  f233bc07 | C:\Spiele\Steam\steamapps\common\Arma 3\!Workshop\@Photon VFX - Smoke
20:59:40                                         Photon VFX |          @Photon VFX |      false |      false |             GAME DIR | d3775e3d4c478a06d496dcf8148f86c6b9b65407 |  8bf37d2a | C:\Spiele\Steam\steamapps\common\Arma 3\!Workshop\@Photon VFX
20:59:40         JSRS Soundmod 2025 Beta - AiO Compat Files | @JSRS SOUNDMOD 2025 Beta - AiO Compat Files RC3 |      false |      false |             GAME DIR | d3abadfaba1d7010bb3a0b92f1c8ed37e7e5ade6 |  adbae34a | C:\Spiele\Steam\steamapps\common\Arma 3\!Workshop\@JSRS SOUNDMOD 2025 Beta - AiO Compat Files RC3
20:59:40                                   Better Inventory |    @Better Inventory |      false |      false |             GAME DIR | 07f27b642dc965a159997583bba5b8d65dd92f8f |  a930c0ba | C:\Spiele\Steam\steamapps\common\Arma 3\!Workshop\@Better Inventory
20:59:40                               Zeus Enhanced 1.15.1 |       @Zeus Enhanced |      false |      false |             GAME DIR | a61552f15b089dd008af93546a21201149fcb5e8 |  962056a3 | C:\Spiele\Steam\steamapps\common\Arma 3\!Workshop\@Zeus Enhanced
20:59:40                 JSRS Soundmod 2025 Beta RC3 - Beta | @JSRS SOUNDMOD 2025 Beta - RC3 |      false |      false |             GAME DIR | c73656d8fe9fc580d22a3281977adee3d41ed17e |  6725cd05 | C:\Spiele\Steam\steamapps\common\Arma 3\!Workshop\@JSRS SOUNDMOD 2025 Beta - RC3
20:59:40                           Advanced Developer Tools | @Advanced Developer Tools |      false |      false |             GAME DIR | 08a1a36873cad6f00eb77d758bb91ad71b378cc6 |  18d40956 | C:\Spiele\Steam\steamapps\common\Arma 3\!Workshop\@Advanced Developer Tools
20:59:40                      Community Base Addons v3.18.4 |              @CBA_A3 |      false |      false |             GAME DIR | 4d05289ad8f2abd14f295946595110d644a8e162 |  216884a8 | C:\Spiele\Steam\steamapps\common\Arma 3\!Workshop\@CBA_A3
20:59:40                               3den Enhanced v8.7.1 |       @3den Enhanced |      false |      false |             GAME DIR | dc9320183b4454c59b8d54829a1cca68594d922a |  ddbd242a | C:\Spiele\Steam\steamapps\common\Arma 3\!Workshop\@3den Enhanced
20:59:40             Global Mobilization - Cold War Germany |                   GM |      false |       true |             GAME DIR | cd2092da7a96b1998cbd242fd79b2cf0d78e8ed3 |  3a8ca649 | C:\Spiele\Steam\steamapps\common\Arma 3\GM
20:59:40                                  Arma 3 Art of War |                  aow |       true |       true |             GAME DIR | 9aee3b774d6270534036f36b495ef477d0811e0d |  7a3fd23a | C:\Spiele\Steam\steamapps\common\Arma 3\aow
20:59:40                          Arma 3 Contact (Platform) |                enoch |       true |       true |             GAME DIR | 042e055abdcbbdee107138bdacd73d4e084b2d1a |  46981d1a | C:\Spiele\Steam\steamapps\common\Arma 3\enoch
20:59:40                                       Arma 3 Tanks |                 tank |       true |       true |             GAME DIR | bc59552ba75b8a009f7b691ddf3493c932170fbf |  322ac721 | C:\Spiele\Steam\steamapps\common\Arma 3\tank
20:59:40                                     Arma 3 Tac-Ops |               tacops |       true |       true |             GAME DIR | a6fc16de1fbaa45986fbabb592f2e5cddb21b8d0 |  9f4e6826 | C:\Spiele\Steam\steamapps\common\Arma 3\tacops
20:59:40                                 Arma 3 Laws of War |               orange |       true |       true |             GAME DIR | 2b1592179785e9460a47875fe2aef5c6751c73e3 |  32cfcb0d | C:\Spiele\Steam\steamapps\common\Arma 3\orange
20:59:40                                      Arma 3 Malden |                 argo |       true |       true |             GAME DIR | 37cc08634034544265c321e01536e1221fd15d3e |  eb442c52 | C:\Spiele\Steam\steamapps\common\Arma 3\argo
20:59:40                                        Arma 3 Jets |                 jets |       true |       true |             GAME DIR | 35e6523569f6b301fb81947b67442246de2a6ed1 |  8b4af371 | C:\Spiele\Steam\steamapps\common\Arma 3\jets
20:59:40                                        Arma 3 Apex |            expansion |       true |       true |             GAME DIR | e6735a0d879287f717d7f9f51305d610d2d07472 |  82d83132 | C:\Spiele\Steam\steamapps\common\Arma 3\expansion
20:59:40                                    Arma 3 Marksmen |                 mark |       true |       true |             GAME DIR | 9a4f9ca1ac46482caa2faa8b5c4ce7edc405de3a |  8152a08e | C:\Spiele\Steam\steamapps\common\Arma 3\mark
20:59:40                                 Arma 3 Helicopters |                 heli |       true |       true |             GAME DIR | d3bf7794d8db623408e73e263f2d78225cc38b29 |  6a67d97a | C:\Spiele\Steam\steamapps\common\Arma 3\heli
20:59:40                                       Arma 3 Karts |                 kart |       true |       true |             GAME DIR | 212a40e9ba530e91018444a290ffe7570e6aa9a3 |  f9bd46ab | C:\Spiele\Steam\steamapps\common\Arma 3\kart
20:59:40                                        Arma 3 Zeus |              curator |       true |       true |             GAME DIR | e35f3b2833c2e846039382b15c8c21674ee804b5 |  640e771a | C:\Spiele\Steam\steamapps\common\Arma 3\curator
20:59:40                                             Arma 3 |                   A3 |       true |       true |    NOT FOUND (Empty) |                                          |           | 
20:59:40 ==========================================================================================================================================================================================================
""",
"difficulty" : "Veteran",
"Other":
"""Original output filename: Arma3Retail_DX11_x64
Exe timestamp: 2025/06/24 13:00:10
Current time:  2025/08/06 20:59:33

Type: Public
Build: Stable
Version: 2.20.152984

Allocator: C:\Spiele\Steam\steamapps\common\Arma 3\Dll\tbb4malloc_bi_x64.dll [2017.0.0.0] [2017.0.0.0]
PhysMem: 32 GiB, VirtMem : 131072 GiB, AvailPhys : 19 GiB, AvailVirt : 131068 GiB, AvailPage : 40 GiB, PageSize : 4.0 KiB/2.0 MiB/HasLockMemory, CPUCount : 8"""
}
