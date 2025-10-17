// This file is to help me understand space filling curves well enough to use in code
// First a Moore curve (closed Hilbert variant) using BOSL2 turtle()


include <BOSL2/std.scad>  // brings in turtle() and stroke()s
// ---- Example ----
$fn = 2;
$fa = .25;




function moore_axiom() = ["L","F","L","+","F","+","L","F","L"];
function rule_L() = ["-","R","F","+","L","F","L","+","F","R","-"];
function rule_R() = ["+","L","F","-","R","F","R","-","F","L","+"];

function rewrite_step(seq) =
    [ for (t = seq)
        each((t=="L") ? rule_L()
            : (t=="R") ? rule_R()
            : [t])
    ];

function rewrite_n(seq, n) = (n<=0) ? seq : rewrite_n(rewrite_step(seq), n-1);

// Make a FLAT turtle command list: ["move", step, "left", ang, ...]
function tokens_to_turtle_cmds(tokens, step, ang=90) =
    [ for (t = tokens)
        each (
            (t=="F") ? ["move", step] :
            (t=="+") ? ["left", ang]  :
            (t=="-") ? ["right", ang] :
            []                         // drop L/R
        )
    ];

function moore_curve_cmds(order=2, step, ang=90) =
    tokens_to_turtle_cmds(rewrite_n(moore_axiom(), order), step, ang);

function moore_path(order=2, step, ang=90) =
    turtle(moore_curve_cmds(order, step, ang));

// Draw as a stroked polygon (Moore curve is closed)
module draw_moore(order, width=0.4, ang=90) {

sizeOfSquareInMM = 100;

cells = 4 * pow(4, order);

sizeOfEachCell = 100 / pow(cells, .5);


    path = concat(moore_path(order, sizeOfEachCell, ang), [moore_path(order, sizeOfEachCell, ang)[0]]);;
    translate([sizeOfEachCell/2, (sizeOfSquareInMM/2) - sizeOfEachCell/2, 0])
    stroke(path=path, width=width,     joints="cross",
       joint_width=1.00,      // enlarge the joint shape
       joint_length=1.00,
       joint_angle=90,       // rotate the diamond so it looks “pointy”
       joint_color="blue");
      
}



order = 6;



//dcolor("steelblue")
linear_extrude(height = 5, center = false, scale = 1.0)
//draw_moore(order, step=(.8), width=(.40));
draw_moore(order, width=(.050));

translate([0,0,5])
linear_extrude(height = 5, center = false, scale = 1.0)
draw_moore(5, width=(.5));

translate([0,0,10])
linear_extrude(height = 5, center = false, scale = 1.0)
draw_moore(4, width=(.5));

translate([0,0,15])
linear_extrude(height = 5, center = false, scale = 1.0)
draw_moore(3, width=(.040));

translate([0,0,20])
linear_extrude(height = 5, center = false, scale = 1.0)
draw_moore(2, width=(.5));

translate([0,0,25])
linear_extrude(height = 5, center = false, scale = 1.0)
draw_moore(1, width=(.040));

translate([0,0,30])
linear_extrude(height = 5, center = false, scale = 1.0)
draw_moore(0, width=(.040));




