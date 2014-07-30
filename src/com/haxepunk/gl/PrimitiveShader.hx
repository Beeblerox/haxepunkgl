package com.haxepunk.gl;

import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.utils.Float32Array;

import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Point;

import com.haxepunk.gl.filter.Filter;


/**
 * ...
 * @author djoker
 */
class PrimitiveShader
{
private var shaderProgram:GLProgram;
	
 public var vertexAttribute :Int;
 public var colorAttribute :Int;
 public var projectionMatrixUniform:Dynamic;
 public var modelViewMatrixUniform:Dynamic;
 public var m:Float32Array;


	
	public function new() 
	{

   m = new Float32Array(16);

var vertexShader = GL.createShader (GL.VERTEX_SHADER);
GL.shaderSource (vertexShader, Filter.colorVertexShader);
GL.compileShader (vertexShader);

if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) 
{

throw (GL.getShaderInfoLog(vertexShader));

}


var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
GL.shaderSource (fragmentShader, Filter.colorFragmentShader);
GL.compileShader (fragmentShader);

if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) {

 throw(GL.getShaderInfoLog(fragmentShader));

}

shaderProgram = GL.createProgram ();
GL.attachShader (shaderProgram, vertexShader);
GL.attachShader (shaderProgram, fragmentShader);
GL.linkProgram (shaderProgram);

if (GL.getProgramParameter (shaderProgram, GL.LINK_STATUS) == 0) {


throw "Unable to initialize the shader program.";
}

vertexAttribute = GL.getAttribLocation (shaderProgram, "aVertexPosition");
colorAttribute = GL.getAttribLocation (shaderProgram, "aColor");
projectionMatrixUniform = GL.getUniformLocation (shaderProgram, "uProjectionMatrix");
modelViewMatrixUniform = GL.getUniformLocation (shaderProgram, "uModelViewMatrix");

 		
	}

	public function Enable()
	{
	   GL.useProgram (shaderProgram);
       GL.enableVertexAttribArray (vertexAttribute);
	   GL.enableVertexAttribArray (colorAttribute);


	}
	public function Disable()
	{
		GL.disableVertexAttribArray (vertexAttribute);
		GL.disableVertexAttribArray (colorAttribute);
		GL.useProgram (null);
	}
		public function dispose()
	{
		GL.deleteProgram(shaderProgram);

	}
	public function setProjMatrix(mat:Matrix3D)
	{
   // GL.uniformMatrix3D(projectionMatrixUniform, false,null);
 
		 for (index in 0...16) 
		 {
            m[index] = mat.rawData[index];
        }
	   GL.uniformMatrix4fv(projectionMatrixUniform, false, m);
	   
	   	//GL.uniformMatrix4fv(uniform, false, #if html5 matrix.toArray() #else new Float32Array(matrix.toArray()) #end );
		
	
   	}
	public function setViewMatrix(mat:Matrix3D)
	{ 
		// var m:Float32Array = new Float32Array(16);
		 for (index in 0...16) 
		 {
            m[index] = mat.rawData[index];
        }
	   GL.uniformMatrix4fv(modelViewMatrixUniform, false, m);
	
    //GL.uniformMatrix3D(modelViewMatrixUniform, false, mat);

	}
}