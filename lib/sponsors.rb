require 'csv'
module Sponsors
  
  def self.sixteen_bit
    gaymers = <<-DOC
    Greater Than Games: http://sentinelsofthemultiverse.com/
    Hold The Line: http://www.holdtheline.com
    Looney Labs: http://www.looneylabs.com/
    SharkRobot: http://www.sharkrobot.com
    So Much Drama Studios: http://www.somuchdramastudios.com/
    The Rough Trade Gaming Community: http://roughtradegamingcommunity.org/
    DOC
    YAML.load(gaymers.strip_heredoc)
  end
  
  def self.eight_bit
    gaymers = <<-DOC
    Adam Holden
    Anthony Sebastian Abrahamsen
    Gil Benezer
    James Hotelling
    Kyle B
    Lord Balentin Gonzales
    Michael Klucher
    Nathaniel Ekoniak
    Paul G. Scott
    Trevor Orestes
    DOC
    gaymers.strip_heredoc.split("\n").collect(&:to_ascii)
  end
  
  def self.five_hundred
    gaymers = <<-DOC
    Alexa and William Callahan
    Eric Merrill
    Jarrod Gilbreath
    Joshua T. Greenfield
    Michael DeLeo
    Perplexing Cabinet, LLC
    Robert Khoo
    Rocky and Sean
    TJ Foust
    DOC
    gaymers.strip_heredoc.split("\n").collect(&:to_ascii)
  end
  
  def self.three_fifty
    gaymers = <<-DOC
    CG
    Adam Paul Holden
    C. Jacobs
    Danny Taing
    EclekTech
    Heather Snodgrass
    Joe L
    The AbleGamers Foundation
    DOC
    gaymers.strip_heredoc.split("\n").collect(&:to_ascii)
  end
  
  def self.two_fifty
    gaymers = <<-DOC
    Airika
    Andy Moore
    Ariel Kaiser
    Corey Lay
    Drew Tabb
    Eric Vecerina
    Erik Clippard
    Jaime Woo
    Jamie Culpon
    Joey J
    John Stockdale
    Keith pearson
    Mario Baumann
    Pixelated Rainbows
    RazzInTown
    Rene Barraza
    Renee Cardineau
    Roy Zemlicka
    Tod Companion
    Winnie Tong Photography
    DOC
    gaymers.strip_heredoc.split("\n").collect(&:to_ascii)
  end
  
  def self.two_hundred
    gaymers = <<-DOC
    Adam Zielinski
    Adrian Sotomayor
    Amaya Booker
    Andrew Fafoutakis
    BLAKE JORDAN
    Bradley "The Boss" Grey
    Charles Lee
    Cheston Lee
    chetchez
    Derek "i-Lander" Eclavea
    Erica "Vulpinfox" Schmitt
    Gordon Bellamy
    James McGeorge
    Jason Walton
    Jon-Enee Merriex
    josh levin
    Joshua Meadows
    Lars
    Logan "HakuroDK" McLaughlin
    Michael Keeton
    Robert Alan Brookey
    Robert Black (Bostorm)
    Tim Shea
    Toan Nguyen
    DOC
    gaymers.strip_heredoc.split("\n").collect(&:to_ascii)
  end
  
  def self.one_fifty
    gaymers = <<-DOC
    Aaron Tidball
    Adrien Hendricks
    Allen Corona and Mark Shrayber
    Angus & Leigh Smith
    Ben Gertzfield
    Brian & Vanessa Bentley
    Craig "Cerrav" Ervin
    Danny&Cody
    David Shafer and Barry Randall
    Don DeWolfe & Chris James
    DW and C-Ro
    Eric C. Oliveira
    H. Poteat
    James Morris
    Jimmy Lujan
    Joe Takacs & Ben Bisbee
    John Stevenson Elder
    Justin Libby
    Landon & Cody
    Lani Wong & Sean Bassett
    Louis Thomas
    Mark A. Brown
    Mateo and Jacob
    Mr. Pappardelle
    Myke Mansberger
    Rambo and Ruby
    Richard Gricius
    Rob Roberts
    Simon Stewart-Rinier
    Spencer Ruelos
    Thom Watson
    Trevor Scott Key
    Troy Hewitt
    Vanessa & Jessica
    Zach Rankaitis
    Richard Clayton
    Matt "m@" Boch
    Sean L Riley
    Anonymous
    DOC
    gaymers.strip_heredoc.split("\n").collect(&:to_ascii)
  end
  
  def self.one_hundred
    gaymers = <<-DOC
    Adam Lucas
    Alana "askfortrouble" Salom
    Alex Woolfson - Yaoi 911
    Alicia Edmunds
    Anthony Derrick
    Ashley Morgan of the Awesome
    Attica
    bastih
    Ben the Diceman
    Bernard Rook
    Bill "Father Azerun" Jahnel
    Boris Hussein Erickson
    Brandon R. Walker
    Brenan L. Peterman
    Brett
    Brett Snider
    Brycen Ainge
    Carl Cheng
    Carl Rigney
    Chad Graber
    Charlie Huguenard
    Charlie Logan
    Chau Nguyen
    Chris Severin
    Chuck Childers
    Cody Benner
    Colin Duffy
    Cory S.
    Dan Mauterer
    Daniel "GodGrind" Valencia
    Daniel Gardner
    David "Tiny415" Whelan
    David Nims
    Derek Knutsen
    Drizzt
    Electronic Dan
    Eric Hulsey
    Eric Tucker
    Ethan Hixson
    Felonintendo
    Filip "Aikho"
    Guy Burns
    Harrison Tanne
    Hung Nguyen
    Ian Ho
    Initial P
    J. Morgan Ewing
    James "DexX" Dominguez
    James Pendergrast
    Jason "ShivanJay" Freitas
    Jason Hobson
    JD Austin
    Jeff Atkins (aka Nonslaught7)
    Jerry Luke
    Jesse Jacobson
    Jessica Ledbetter
    John B Fugate
    John de Freitas  (aka FuzzNugget)
    John LeMay
    Jojo Stratton
    Jonathan 'bouxdag' Smith
    Jonathan A.
    Joseph Huckaby
    Josh Napohaku
    Kara
    Keith "kimchi" Mitchell
    Kelsa
    Kensuke Nakamura
    Kerry Freeman
    Kori Michele Handwerker
    Kristin Lindsay
    Kristine Hassell and Andy Munich
    Kythera of Anevern
    Lee Abadie
    Linnsey Miller
    Luke
    Luke Hedin
    MARIO RAUL JARA
    Mark Davis
    Marshall K.
    Marty
    Matt Lemieux
    Matthew Michael Brown AKA Gaymer
    Matthew Walke
    Michelle Ferreirae
    Miguel A. Lopez
    Mike Drew
    Mike Pohlable
    Mike Thomas
    Mike W.
    Mikey Love
    Neshoba78
    Noah Silas
    Panictehnawt
    Patrick Carpenter
    Queuethulu Games
    Radicaldreamer13
    Ri'en Karrot
    Rob Jagnow
    Robb Utesch
    Robert Scott
    Robin Payne
    Ron 'Coyote' Lussier
    ScottJL
    Spinfusor
    Stephen Ulrich
    Steven
    Steven Tang
    TheWillofDC
    Todd Cook
    Todd Jonker
    TORONTO GAYMERS
    Trafton
    Vern Y.
    Vic Ayers
    Violet Kerrigan
    Violette P.
    Vitali
    Zach Sanford
    DOC
    gaymers.strip_heredoc.split("\n").collect(&:to_ascii)
  end
  
  
  def self.gaymers
    gaymers = <<-DOC
    }BRO{ eggs
    @flotastisch
    @Foion
    @seldo
    @theroyalcactopi
    #heysailor
    <3 Scott Davis :D
    A.J. Mendoza
    Aara Golpad
    Aaron A. Reed
    Aaron Dillard
    Aaron Joseph Larson
    Aaron Laibson
    Aaron McNeal
    Aaron Rothman
    adahn6
    Adam Buckheit
    Adam Edwards
    Adam Simon
    Adam Young
    Adri Haik
    Adrian Herbez
    Adrian Mailenna
    Al Gonzalez
    AladinSane
    Alan Watterson
    alex
    Alex A. and Zach W.
    Alex and Schuyler
    Alex Barbieri
    Alex Mantoura
    Alex Sammak
    Alex Ziebart
    Alexander Belzer
    Alexander F.
    Alexander Meza
    Alexander Perkins
    Alexander van Oostveen
    Alexandre van Chestein
    Alexei Othenin-Girard
    Alexis Ohanian
    Alf Pardo
    Alice Karsevar
    Alison Woods
    Allanah Kate
    Allen Chen
    Allen Murray
    Alli Thresher
    Allison from We Are Geek Girls
    Allison Hill
    Allison O
    Ally L.
    Alucard
    Alvin Chen and Mark Hopkins
    Amanda Benson
    Amanda Pullum
    Amanda Ramsey
    AmanM
    Amber E. Scott
    Amber Goad
    Amber Ryan
    Amethyst Snowfall, Kieco
    Amy Harrison
    Amy Lewis
    anarchymarie
    Anath
    Andre Bermudez
    Andreas Larsson
    Andrei Mouravski
    Andrew "Sh0kwav" Hess
    Andrew East
    Andrew Ferguson
    Andrew Lim
    Andrew Molloy
    Andrew Watterson
    Andy Bene
    Andy Dixon
    Andy Fyfe
    Andy Young   /  Justin Wind
    Ang Jandak
    Anita Sarkeesian
    Anna Washenko
    Anne Lee
    Anne Marie "Jynxed" Greco
    Anonymous
    anonymous
    Anonymous
    Anonymous
    Anonymous
    anonymous
    anonymous
    Anonymous
    Anonymous
    Anonymously
    Anthony
    Anthony Brewer
    Anthony Gentile
    Anthony J. Magnia
    Anthony Sass
    Antonio H.
    Arenlor
    Ari Edwards
    Art Dahm
    Artists' Internet Radio (www.ArtistsInternetRadio.com)
    artoni
    Aseroff
    Ashiya L.
    Ashley Rayner
    Athelstan
    Audryana Knippert
    Austin Goetchius
    Austin Kruckmeyer
    Barbara Wilkinson
    Battershell
    Becky Chambers
    Bekkir Barbier
    Ben Lehman
    Ben PerLee
    Ben Schwartz
    Ben Trigg
    Ben Wilhelm and Natalie Rog
    Benjamin Wahlberg
    Benjamin Wilson
    Bespoke Software Solutions
    Bethany Bailey
    Biggest Fans!!11!!11!!!!
    Birchell Eversole
    Blair Durkee
    Bo Williams
    Boo Jarchow
    Boolean
    Br0dee
    Brad and Gretchen
    Bradley Baker
    Bradley Eng-Kohn
    Bran / kung-fu lasers
    Brandon Beall
    Bravarian Paw Studios
    Brenda Z (squishynin)
    Brendan Adkins
    Brendan Howard a.k.a. bluuberg
    Brendan Mason
    Brett A. Murphy
    Bri
    Brian Cooper
    Brian Face
    Brian Hofmeister
    Brian Hubble
    Brian Kunde
    Brian O.
    Brian Rubin and Toby Sowers
    Brian, A Cook and a Geek
    Brianna Dardin
    Brookie Judge
    Bryan Mosher
    Bryant Durrell
    BubbaQuest
    C&B
    Cade "CadeRageous" Peterson
    Caitlin Lopez
    Calvin Bonna
    Captain Starbring
    Cariad Eccleston
    Carl
    Carl Bou Mansour
    Carly Trautwein
    Carrie Myers
    Carrington Vanston
    Carter Gibson
    Casey Botkin
    Casey Bouknight
    Casey Lawler
    Casey Lent
    Cat Prince
    Catherine Shyu
    Cathy Burkholder
    cdkersey
    Cee Ng
    Chad Treece
    Chandler Poling
    Charlemagne Thunderspine
    Charles "GeekDaddy" Boylan
    Charles "Zan" Christensen
    Charley Mills
    Charley Reed
    Charley Sheets
    Charlie Townley
    Charlotte
    Chase Erwin & Tyler McPherson
    Chason Chaffin
    Chaz Estell
    chip Sbrogna
    Chip Smith
    Chris
    Chris & Jer
    Chris Catignani
    Chris Chan
    Chris Esqueda  and  Sarah Day
    Chris Healy
    Chris Holdren
    Chris Jennewein
    Chris Salcedo
    Chris Schroyer
    Chris Scutcher
    Chris V
    Chris Wolfe
    Chris Yeoh
    Christine "crunchy"
    Christine Standley
    Christopher
    Christopher "Riot" Mason
    Christopher "Stu" Lange
    Christopher Agius
    Christopher Corneschi
    Christopher Noessel
    Christopher Swenson
    Christopher Tilley
    Cian Quattrin
    Cindy Au
    Cody Rossler
    Cointower Creative
    Cole Morrison
    Colin Cox and Menkah Mathews
    Colin Matthew
    Colin McIntyre
    Connie Palmore
    Connor Duffey
    Conor Mullen
    Conor Stephenson
    Coriander
    Craigums
    Crystal Huff of Readercon
    Crystal Steltenpohl
    Cyb
    cycene
    D20 Burlesque
    Damond A
    Dan Leveille
    Dan Lovell
    Daniel Atherton
    Daniel Giovanni Villalobos
    Daniel H
    Daniel Ross
    Daniel Villanueva
    Daniel Villarreal and Michael Maldonado
    Dannie Phan
    Dannielle Pence
    Danton Tsang
    Darcy Town
    Darkshifter
    Dave and Brad
    Dave Tu
    DaveL
    David "KingDavid73" King
    David & Matthew
    David A. Watanabe
    David Baumgold
    David Brockman Smoliansky
    David Delo
    David Gladstein
    David L. Ketcham
    David Panek
    David Poon
    David R-S
    David Ruiz
    David Seccombe
    David Shambaugh
    David Stamm
    David Yenoki
    dawin
    Dax Cushman
    DDL
    Debra Phillips and Katharine Emerson
    decultured
    Delos Russell Hawkins
    Dennis - Switzerland
    Depressed Panda Studios
    Derek Finn
    Derek Foote & David Radford
    Derrick Coetzee
    Derryn
    DesertIcicle
    Dex Craig and Paul Jack
    Dieter Wolfram
    Dimitri Brook
    DJ Siewert
    Dom Moylett
    Dominic Aquilina
    Don Tyler Wooldridge
    Donna "Danicia" Prior
    Donna Evans
    Donnie Hatcher
    Doug Hagler
    Dr Benjamin "Purple" Joly
    Drake Delmar
    Drew
    Dryuma Boba
    Duck Dodgers
    Dustin Garrett
    Dustin Green
    Dustin Manuel
    Duy Tran
    Dwight Boardman
    Dylan Gould
    Dylan Travers
    Ed Fleming
    Eddie Hsieh
    Eduardo Ramirez
    Edwin Aoki
    Eevil
    Eliot Lash
    Elliot
    Elliott LeClaire
    Eloy Lasanta
    Em Orzol
    Emily Floyd
    Emma Story
    Enkelli
    Epidemic
    Eric "Dragonsong" Duncan
    Eric G
    Eric Hall
    Eric Hudson
    Eric n' Chris :@
    Eric Naeseth
    Eric Olson
    Eric S
    Erica K
    Erickson Warne-Coles
    Erika Sadsad
    Erin Sterling
    Ernie Martinez
    Esteban Santana Santana (MentalPower)
    Ethan Gomes A.K.A. Diagas
    Ethan Trooskin-Zoller
    Ev'Rynn
    Evan Favreau
    EvilKnight
    Ezra Karsk
    F. Wesley Schneider
    Faye Tyson & Ryan Ekhoff
    Fire Escapes for iOS 
    Fitz Bailey
    Flame On! Gay Geek Podcast
    Frag Dean
    Frank & Steven Munky
    Frank and Katherine
    Frank J. Manna
    Frank Serio, Jr
    Frank-Joseph Frelier
    FrankieSmileShow
    Frederick Swetland IV
    Friggin' Games
    FUnhaver Games
    Gabrial Fox
    Gabriel & Freddy
    Gabriel Roland
    Gabriel Veiga
    GameCouch
    GameCraft Miniatures
    Gamer_152
    Gamerstable Podcast
    Garland Easter III
    Garou Verroq
    Garrett Mickley
    Gawain Lavers
    Genevieve Dodd
    Genny Engel
    George Cole
    George Fielding AKA Ignatius Cheese
    George H.
    gianmarco fongaro
    Gil Almogi, Francesco Pascuzzi
    Giordano Bruno Contestabile
    Giorgio "Jerzat" Ciapponi
    Giovanna Lynch
    Glenn "Justicar" White
    Gogisha
    Golden
    Grace F.
    Greer Hauptman
    GREG CHEETAHMEN PABICH
    Greg Gloria
    Greg Taylor
    Gregory Varnum & Bobby Proffer
    Gregory Wilson
    Gregory Wu
    Grey Thompson
    griphus
    Gus Z
    GutLlar
    Guy
    H Lynnea Johnson
    H. Anthe Davis
    Hailey and Rachel <3
    Hamp Freeman
    Hans Schuschel
    Harlequin Heartz
    Harry Slack
    Haydn (HHH247)
    Heina Dadabhoy
    Helge
    Hell's Tunas Motorcycle Club
    Hereagain.blog.com
    hhhiryuu
    Highland Dryside Rusnovs
    Hiryuu Honyaku
    HK
    Howey
    HRM David Austin Peters
    Hugh J. O'Donnell
    HUmarMasta
    Huu
    Ian Broderick
    Ian Klein
    Innocent
    Israel Ehrisman
    Isthral Koss
    J Scott Knell
    J. Haycraft
    J. Trixie & L. Louie
    J.D. Case Xbox GT: major20
    Jack Bogdan
    Jack Frazee
    Jack Phillips
    Jaclyn Jimenez
    Jacqueline Urick
    Jae Kim
    Jake Sones
    Jakub HloZek
    James ' Cpt. Spike' Anger
    James | Dancing Geek
    James Edward Johnson
    James Godfrey
    James okiraan Campbell
    James Parker
    James Pond
    James Riggall
    JAMES SPRUNT COMMUNITY COLLEGE
    James Turnbull
    James White, Benjamin Everly
    Jamie Dutton
    Jamie Jung
    Janet Etches
    Jarath Hemphill
    Jared
    Jared Cohen
    Jared D Cuslidge
    Jared F
    Jared Petersen
    Jared Roper
    Jasmine Gower
    Jason
    Jason A. Regina
    Jason Blevins & Meg Green
    Jason Eslinger
    Jason Lea
    Jason McVicker
    Jason Ratlif & Chris Elliott
    Jason Varvas
    Javier Agud Herrero
    Javier Morales
    JAWs
    Jay "Null Flow" Kim
    Jay Donachie
    Jay Gelnett
    Jay Paguio
    Jay Sittler
    jazzdaughter
    Jeff Allred
    Jeff C
    Jeff Cardillo
    Jeff Henson
    Jeff W. Richards
    Jeffervescent
    Jeffery Redcloud Barros Jr
    Jeffrey Martin
    Jeffrey Norman Bourbeau
    Jen Sylvia
    Jenn Malak
    Jenn Mercer
    Jennie Drummond
    Jennie Mae Sweat
    Jennie Schilling
    Jennifer P.
    Jennifer Pan
    Jennilee Truong
    Jeremy Geist
    Jeremy Kostiew
    Jeremy Mitchell <3 William Clark
    Jeremy-Augustus Josafat [[Jerms]]
    jermm
    Jess Haskins
    Jesse Cortez
    Jesse Crump
    Jesse Meikle
    Jessica
    Jessica Berglund
    Jessica Hammer
    Jessica Murray
    Jessica V. Bautista
    Jessica Zorich
    Jesus Mazariegos
    Jillian M. Pullara
    Jim "Sylvan" Sullivan
    Jim Anderson
    Jimmy
    Jimmy Nguyen
    Jimmy O'Dwyer
    Jisuk Cho
    Jo Burba
    Joan Leib
    Joanna Robson
    jobias
    Joda Cast
    Joe Flores
    Joe Lencioni
    Joe Lunn
    Joe O'Hara & Trevor Kettelkamp
    Joe Pease
    Joel Barcham
    Joel Kevin Villegas
    Joel Stephenson
    Joey Brunelle
    Johann Grimm
    John & Kevin
    John Bellando
    John Bremseth
    JOHN ETERNAL
    John Goff
    John James
    John Jones
    John Kiyak
    John LeBoeuf-Little
    John Ogden
    John P.
    John Spiers
    John Stewart
    John Sykes
    John U
    JohnRhic M. Candelaria and Issac Garza
    Jon Corker
    Jonathan A
    Jonathan Cook
    Jonathan Escobedo
    Jonathan Kirby
    Jonathan Rosenberg
    Jonathan Schuppert and Jared Lilly
    Jonny Leahan
    Jordan
    Jordycub
    JOrg Reisig
    Joris
    Joseph "Joey" Santamaria
    Joseph Blocker
    Joseph Compton
    Joseph Delahanty
    Joseph Mann
    Josh Clow
    Josh Considine
    Josh Cook
    Josh Drobina
    Josh Garon
    Josh Ols
    Josh Opatowsky
    Josh Parker
    Joshua A.C. Newman
    Joshua Klooster, A godless anarchist and a gentleman of distinction
    Josie Walker and her mom
    JT Murphy
    Jude Jackson
    Julian Mehlfeld
    JulianK
    Julien Jalon
    Jungle Rat Rob
    Jussi Kenkkil
    Justin A. Chortie
    Justin and Liz
    Justin David Miracle
    Justin Dent
    Justin Ferreira
    Jyri "KEK7go" Tasala
    K. Gonzales
    Kainti
    Kaleb Grace
    Kallizm
    Kameron Alexander
    Kameron Kitajima
    kamo
    Kanane Jones
    Karin M
    Karina
    Karl Maurer
    Kat Chappell
    Kate Kirby
    Kate Lubeck and Lizzy Donahue
    Katelin Powers
    Kater
    Katie Armstrong
    Katrina Lehto
    Kawai Wong
    Kay Mushi supports YOU! Gaymers of the world, unite
    Keaven Freeman
    Keith Kurson
    Kelly Dawson
    Kelly Raila
    Kelsey Toy
    Ken Hurst
    Ken Lowery
    Ken Norton
    Kenny @ Curse
    Kent
    Kev & Sarah Wojnarski
    Kevin Adamski
    Kevin C. Love
    Kevin Carey
    Kevin Clark
    Kevin Douglas
    Kevin F. Davila
    Kevin G. Vanderhoff
    Kevin Hamano (aka ksquad)
    Kevin McCarthy
    Kevin N.
    Kevin Slackie
    Kevin Toovey
    Kevin Wong
    kevinchai
    Ki Nguyen, Suzi, Romeo Garcia, Gerard Reyes
    Kimberly Voll
    Kirsten M. Berry
    Kit La Touche
    Korey Burns
    KoTxE
    KovuTheHusky
    Krazy XP
    Krellan & Teloric
    krishna prasad
    Kristen Brandt
    KSC
    Kshitij Sobti
    Kurt Karl Goldfarb
    Kylan Coats
    Kyle
    Kyle Coffey
    Kyle Davis
    Kyle Dennis
    Kyle J. Rothfus
    Kyle Koors (NP Sage)
    Kyle S
    Kyle Viehmann
    Kyle W. Wallpe
    Kyle West
    Kymberlie R. McGuire
    Lan
    Lance Craig
    Laura "Fairyglass" Bishop
    Laura l'Orage Billard
    Lawjick
    Leandro Moretti
    Lee Van Duzer
    Lenore Berry/"Aisu"
    Leo
    Leo-kun!
    Leslie Law
    Leslie Tullis
    Level Up Studios
    Levi
    Levin Sadsad
    Lilibat
    Lindsay Walter
    Lisa Robin Nelson
    Lisa Weiss
    Loiseau
    Lorin "Xavier" Grieve
    Lost Decade Games
    LuaMilkshake
    Lucas Johnson and Ken Glass
    Ludo ESport
    Luis Ramos-Rosas
    Luke Bannon
    Luke Kelleher
    LurkerGaat
    LuzidRhymez
    Lynnette Gill
    Lyrania
    M.A. Perez
    Mac Kintana
    Mackenzie Williams
    MacNatty
    Madecunningly
    maestroplease
    Maggie McFee
    Mailene Shipe
    Malia Guerrero, The Ladies' Lady
    Marc C. Mangahas
    Marc Egazarian MD FACS
    Marco Maraboo
    Mari
    Marina Rossi
    Mario Mergola
    Mark F
    Mark Pletcher
    Mark Reitblatt
    Mark Vigorito and Austin Horowitz
    Mark, Sam and the Honey Dog
    Martin "Grestorn" Korndarfer
    Martin Hecko
    Mary "Eucyon" Redmon
    Mason McKee
    Matt Denny
    Matt Ebert
    Matt Faustini
    Matt Holland
    Matt Lane
    Matt Loosbrock
    Matt McGinnis
    Matt Schwartz
    Matt Stapleton, Chris Bailey
    Matt Weprin
    Matthew "Toxxik" Lopez
    Matthew Beermann
    Matthew Czubakowski (@mczub)
    Matthew Escobar
    Matthew Ford
    Matthew Gallant
    Matthew Gaudet
    Matthew Herz and James Stinnett
    Matthew Maguire & Armando Mendoza
    Matthew McFarland and Michelle Lyons-McFarland
    Matthew Ragsdale
    Matthew Sullivan-Barrett
    Matthew Weinberg
    Matti McLean
    Mattiekinz Corley
    Matty Tibaldi
    Max C.
    Max Mallory
    Max Stein
    Maxamaris Hoppe
    Maxime Dumont
    Maxime Tremblay
    Maxwell Decker
    Mayka Mei
    MB Finocchiaro
    MDH
    Medel
    Megan and KC
    Megan Bartelt
    Megan Knouff
    Meghan K. Callahan
    Melinda James
    Melissa Donohue
    Michael (G-Nitro) Camacho
    Michael Barr
    Michael Bedar
    Michael Bottom
    Michael Campbell
    Michael Carlson
    Michael Childers
    Michael Cole-Schwartz
    Michael Handler
    Michael Legg
    Michael Schneider
    Michael Sohn
    Michael T. Eastham
    Michael Trapani
    Michael Turnage
    Micheal Stribling
    Michel Yeager
    Michlbert
    mightygupo
    Miike Ramos
    Mike "Monk" Ponsades
    Mike A
    Mike and Alex
    Mike Brown
    Mike Crane
    Mike Drucker
    Mike Hudson
    Mike Moreno & Steve Silvas
    Mike Neimoyer
    Mike Taylor
    Mike Torres
    Mike Wixon
    Miki Habryn
    Miko Charbonneau
    Miles Preclaro
    millibeau
    Misty Matonis
    Molly Jameson
    Monique McGraw
    Mr. Axon Hillock
    MrDandyMan
    MrS
    Mutha Oith Creations and Con on the Cob
    Myka-L
    mysterjinx
    N.D. Zeltzer
    Nakon
    Nancy Smith
    Nasika
    Natasha Lewis Harrington
    Nathan
    Nathan Clegg & Brandon Lewis
    Nathaniel Hohl
    Nathaniel Mathews
    Nectar Games - Ken Bowen
    Nelson Minar
    Nicholas George
    Nicholas Reale
    Nicholas Rufus Clemente Fascitelli
    Nick
    Nick & William
    Nick Hahn
    Nick S.
    Nick the Nicholas
    Nicole Eng
    Nicole Frauscher
    Nicole Leffel
    Nigel Pick
    Nik Botkin
    Nik Enloe (CeroLobo)
    nikomonkey
    Nina
    Nina Borchowiec
    NintendoJack.com
    Noah P.
    Noam Rosen
    Nolan & Santoso
    nomoreprinces
    Nori Duffy
    NS
    Nurhil
    O. D. Larson
    Okinopolytrans
    Orkchop; Monica Rosenfield
    Oscar De La Cruz
    osifracrat
    Paige Ponzeka
    Patrick 'Fore' Strouse
    Patrick Donato Mueller
    Patrick Lagua
    Patrick Ossmann
    Patrick Tomas
    Patrik Hanson
    Paul
    Paul C. Anderson
    Paul Hollingdrake
    Paul Jacobs
    Paul Lathrop & Aly Condon
    Paul Scorthorne
    Pearl Wong
    Pedro Rittnee
    Per Aulin
    Pete Curry
    Pete Mitchell and Darren Fitzgerald
    Peter Borah
    Peter Glagowski (KingSigy)
    PFXJ
    Phabio
    Phil Ramsteck
    Philip Wells
    Philippe Chabot
    Phillip Garcia and Matt Clegg
    Phillip Naslund
    Phillip Whitty
    Phoebe Seiders
    PHuZZy
    Pienaru Adrian Teodor
    Piper Chester
    Plastica Obscura
    Plus5Keen
    Poet Mase
    Propriety
    QtRNevermore
    QueentakesRook
    R. Sessions
    Rachael L Morgan
    Rachel Mercer
    Rachel Stokes
    Rafael Alzamora
    Rafael Rocha
    Randy Dickinson
    Randy Geraads
    Ray
    Ray Yu
    Raymond Zhou
    Rebecca Stein
    RectimusPrimal
    Red Fenix LLC
    Red Magnet Media
    Reeves Singleton
    Regis M. Donovan
    Renbot.Steve
    RezClown
    Ricardo Valenzuela
    Richard Lacourciere
    Rick R.
    Rick Raven
    Ricklis shachar
    Ricky Hudgins
    Ringo Alfonso
    Riverboat Gambler Antiques, Inc
    RJ Derrick
    Roac
    Rob "Nectan"" Schell
    Rob Ferguson
    Rob Wygand
    Robin Ward
    Rocket Paw Miniatures
    Rodney Linebarger
    Romain Michalec
    Ron Rucci Jr
    Ron Spalding & Michael Kennedy
    Ron Womelsdorf
    Ronaldo Luiz Pedroso
    Rose Fox
    Ross French
    Ross Shingledecker, Eric Abernethy, and friends!
    Royce Marcus
    Rrain Prior
    RTX
    Rudi Leo
    Ryan Gosewehr
    Ryan Prothero
    Ryan Rincon
    Ryan Soto
    Ryan the Stampede
    S. T.
    Sabine
    Sal
    Sal and Robin Trujillo
    Sam Burnstein and Carolyn Grabill
    Sam Houston
    Sam Kimbrel
    Sam O
    Sam Tsui
    Sam Williams
    Sam Wright
    SAMAKI DORSEY
    Samantha Blackmon, Not Your Mama's Gamer
    Sameer Chopra
    Sameer Yalamanchi
    Samuel Axon
    Samuel Bass
    Samuel Colville
    Samuel Henager
    Samuel Judd
    Sarah Hamilton
    Sarah M. Grissom
    Sarah Michael
    Sco DePriest
    Scott
    Scott & Gabi Woltman
    Scott O.
    Scott Summers & George Wang
    Scribblethief
    Scuttlebutt Ink
    Sean "AzHP" Lee
    Sean Bloom
    Sean Kafer
    Sean P Marks
    Sean Pelkey
    Riley Grey
    Sean Todd
    Serena Organ
    Sergio Israel Ponce
    Seth "Alex" Boyer
    Seth Kingman
    Seth McNitt
    Seth Winkenwerder
    Seto Konowa
    Seumas Froemke
    Sev Hajinian
    Shane St. Hill
    Shanna Germain
    Shannan Rapoport
    Shaun Edmonds
    Shawn
    Shawn L Putnam aka Utahrangerone
    Shawn Walker
    Shea Dietz & Zander Oklar
    Shervyn
    Shiba Scream Studios
    ShiraShira
    Shualdon
    Sid Tsai
    Skid
    Slade Downs
    Sleepygaymer
    solardepths
    Somnigram
    sonictonic
    Spazzle
    Stacie Looney
    Stefan Neudorfer
    Stephanie Miller
    Stephen
    Stephen Harrison
    Stephen J. White
    Stephen Thomas
    Steven Danielson
    Steven Eisinger
    Steven Nelson
    Steven Pawlikowski
    stranamente
    Stryker_kun
    Stuart D. Sopko
    Stuart Rue
    Studio Kontrabida
    Supernatural Tarot
    Sven Holl
    SvenTS
    Synthetic PictureHaus
    T. Scott Moore
    Tague Griffith
    Tarean Jones
    Taybenlor
    Taylor Hicklen, Zach Flauaus
    Taylor Pohl
    Ted Johnson
    Tehkis
    Terence Ng
    Tero Suoniemi
    terralphasia
    Tevin W.
    The Dread Hunts
    The Mehta/Neugebauer Family
    The Skullinane Gaming Institute
    The Stouder-Studenmund Family
    The Village Designs
    The_Exile0901
    Theo Ramage
    TheRedWriter and Dragnmistris
    Thomas Hale
    Thomas Herrick Jr
    Thomas Truong
    Thorsten Busse
    three08 & Christy Hotwater
    Tiffany A. Christian
    Tiffany L. Pascal
    Tim Sherburn
    Tim Shundo
    Tim Stellmach
    TK-421
    Tobi Mayo
    Tobias Cohen
    Tobias Lidman
    Toby Cook
    Todd "Todiyo" Dionson
    Todd Bartoo
    Tom Heistuman
    Tom Katzman
    Tom Lowenthal
    Tomas M
    Tony B.
    Tony Sarkees
    tortilleras
    Tory Republic
    Travis
    Travis Broady
    Trevor
    Trey Zink
    Triften Chmil
    Trin
    Trisha
    Trystan Rundquist
    Turner Allen
    Two Hats Games
    Ty Liang
    Tyber and Cannon
    Tyler Disney
    Tyler Hanan
    Tyler Martin
    Uhura Jones
    ultrafang
    Unca Lar
    vghangover.com
    Vickie W.
    Victor B Andersen
    Viethra
    Vince Dong
    Vincent Deloso
    Vincent Huang
    Vincent Miller, Jonathan Cruz, Ultimate Yaoi Mistress Tien
    Vlad
    W.D. Robinson
    Walnut Hulls
    Walt DeNatale
    Walter Mundt
    warrbo
    Wayne Denier
    Wendy Ashmun
    whitemagus
    Wil
    Will Bonasera
    Will Johnson
    Will Knott
    Will Patton
    Will Roget
    Woggo
    Wolf_Harte
    Wright S. Johnson (Ffordesoon)
    Wyde
    Xcentric Gaymer
    yes
    Ygritte
    zach galvin
    Zachary Davis
    Zachary Neuschuler
    Zackary Collins
    Zaerion
    Zedrick Darke
    Zilla Doty
    Zo
    Zofia Zbiegiel
    Zombie Sky Press
    DOC
    gaymers.strip_heredoc.split("\n").collect(&:to_ascii)
  end
end