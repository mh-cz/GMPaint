/*function vec2plus(v1, v2){
	return [v1[0] + v2[0], v1[1] + v2[1]];
}

function vec2minus(v1, v2){
	return [v1[0] - v2[0], v1[1] - v2[1]];
}

function vec2mult(v1, v2){
	return [v1[0] * v2[0], v1[1] * v2[1]];
}

function vec2div(v1, v2){
	return [v1[0] / v2[0], v1[1] / v2[1]];
}

function vec2times(v1, n){
	return [v1[0] * n, v1[1] * n];
}
*/
function vec2dist(v1, v2){
	return point_distance(v1[0], v1[1], v2[0], v2[1]);
}
