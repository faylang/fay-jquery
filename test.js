/** @constructor
*/
var SameDir = function(){
var True = true;
var False = false;

/*******************************************************************************
* Thunks.
*/

// Force a thunk (if it is a thunk) until WHNF.
function _(thunkish,nocache){
  while (thunkish instanceof $) {
    thunkish = thunkish.force(nocache);
  }
  return thunkish;
}

// Apply a function to arguments (see method2 in Fay.hs).
function __(){
    var f = arguments[0];
    for (var i = 1, len = arguments.length; i < len; i++) {
        f = (f instanceof $? _(f) : f)(arguments[i]);
    }
    return f;
}

// Thunk object.
function $(value){
  this.forced = false;
  this.value = value;
}

// Force the thunk.
$.prototype.force = function(nocache){
  return nocache
    ? this.value()
    : this.forced
    ? this.value
    : (this.forced = true, this.value = this.value());
};

/*******************************************************************************
* Constructors.
*/

// A constructor.
function Fay$$Constructor(){
  this.name = arguments[0];
  this.fields = Array.prototype.slice.call(arguments,1);
}

// Eval in the context of the Haskell bindings.
function Fay$$eval(str){
  return eval(str);
}

/*******************************************************************************
* Monad.
*/

function Fay$$Monad(value){
  this.value = value;
}

// >>
function Fay$$then(a){
  return function(b){
    return new $(function(){
      _(a,true);
      return b;
    });
  };
}

// >>=
function Fay$$bind(m){
  return function(f){
    return new $(function(){
      var monad = _(m,true);
      return f(monad.value);
    });
  };
}

var Fay$$unit = null;

// return
function Fay$$return(a){
  return new Fay$$Monad(a);
}

/*******************************************************************************
* FFI.
*/

// Serialize a Fay object to JS.
function Fay$$serialize(type,obj){
  type = _(type);
  if(type) type = type[0].name;
  if(type == "JsType"){
    return function(){
      return _(obj,true).value;
    };
  } else {
    obj = _(obj);
    if(type == "StringType" ||
       (obj instanceof Fay$$Cons && typeof obj.car == 'string')){
      var str = "";
      while(obj instanceof Fay$$Cons) {
        str += obj.car;
        obj = _(obj.cdr);
      }
      return str;      
    } else if(type == "FunctionType" || typeof obj == 'function'){
      return function(){
        var out = obj;
        for (var len = arguments.length, i = 0; i < len; i++){
          if(typeof out != 'function') {
            throw "Wrong number of arguments for callback: " + arguments.toString();
          }
          out = out(arguments[i]);
        }
        return _(out,true);
      };    
    } else if(type == "ListType" || (obj instanceof Fay$$Cons)){
      var arr = [];
      while(obj instanceof Fay$$Cons) {
        arr.push(Fay$$serialize(null,obj.car));
        obj = _(obj.cdr);
      }
      return arr;      
    } // else if(type == "BoolType || obj == _(True) || obj == _(False)) {
    //   return obj == _(True);
    // } 
    else {
      return obj;
    }      
  }
}

// Encode a value to a Show representation
function Fay$$encodeShow(x){
  if (x instanceof $) x = _(x);
  if (x instanceof Array) {
    if (x.length == 0) {
      return "[]";
    } else {
      if (x[0] instanceof Fay$$Constructor) {
        if(x[0].fields.length > 0) {
          var args = x.slice(1);
          var fieldNames = x[0].fields;
          return "(" + x[0].name + " { " + args.map(function(x,i){
            return fieldNames[i] + ' = ' + Fay$$encodeShow(x);
          }).join(", ") + " })";
        } else {
          var args = x.slice(1);
          return "(" + [x[0].name].concat(args.map(Fay$$encodeShow)).join(" ") + ")";
        }
      } else {
        return "[" + x.map(Fay$$encodeShow).join(",") + "]";
      }
    }
  } else if (typeof x == 'string') {
    return JSON.stringify(x);
  } else if(x instanceof Fay$$Cons) {
    return Fay$$encodeShow(Fay$$serialize(ListType,x));
  } else if(x == null) {
    return '[]';
  } else {
    return x.toString();
  }
}

// Unserialize an object from JS to Fay.
function Fay$$unserialize(typ,obj){
  if(typ == 'string' || typ == 'array' || typ == 'list')
    return Fay$$list(obj);
  else if(typ == 'bool')
    return obj? True : False;
  else if(typ == 'data') {
    alert('Time to unserialize a data record!');
  }
  else return obj;
}

/*******************************************************************************
* Lists.
*/

// Cons object.
function Fay$$Cons(car,cdr){
  this.car = car;
  this.cdr = cdr;
}

// Make a list.
function Fay$$list(xs){
  var out = null;
  for(var i=xs.length-1; i>=0;i--)
    out = new Fay$$Cons(xs[i],out);
  return out;
}

// Built-in list cons.
function Fay$$cons(x){
  return function(y){
    return new Fay$$Cons(x,y);
  };
}

// List index.
function Fay$$index(index){
  return function(list){
    for(var i = 0; i < index; i++) {
      list = _(list).cdr;
    }
    return list.car;
  };
}

/*******************************************************************************
* Numbers.
*/

// Built-in *.
function Fay$$mult(x){
  return function(y){
    return _(x) * _(y);
  };
}

// Built-in +.
function Fay$$add(x){
  return function(y){
    return _(x) + _(y);
  };
}

// Built-in -.
function Fay$$sub(x){
  return function(y){
    return _(x) - _(y);
  };
}

// Built-in /.
function Fay$$div(x){
  return function(y){
    return _(x) / _(y);
  };
}

/*******************************************************************************
* Booleans.
*/

// Are two values equal?
function Fay$$equal(lit1,lit2){
  // Simple case
  lit1 = _(lit1);
  lit2 = _(lit2);
  if(lit1 === lit2) {
    return true;
  }
  // General case
  if(lit1 instanceof Array) {
    if(lit1.length!=lit2.length) return false;
    for(var len = lit1.length, i = 0; i < len; i++) {
      if(!Fay$$equal(lit1[i],lit2[i]))
        return false;
    }
    return true;
  } else if (lit1 instanceof Fay$$Cons) {
    while(lit1 instanceof Fay$$Cons && lit2 instanceof Fay$$Cons && Fay$$equal(lit1.car,lit2.car))
      lit1 = lit1.cdr, lit2 = lit2.cdr;
    return (lit1 === null && lit2 === null);
  } else return false;
}

// Built-in ==.
function Fay$$eq(x){
  return function(y){
    return Fay$$equal(x,y);
  };
}

// Built-in /=.
function Fay$$neq(x){
  return function(y){
    return !(Fay$$equal(x,y));
  };
}

// Built-in >.
function Fay$$gt(x){
  return function(y){
    return _(x) > _(y);
  };
}

// Built-in <.
function Fay$$lt(x){
  return function(y){
    return _(x) < _(y);
  };
}

// Built-in >=.
function Fay$$gte(x){
  return function(y){
    return _(x) >= _(y);
  };
}

// Built-in <=.
function Fay$$lte(x){
  return function(y){
    return _(x) <= _(y);
  };
}

// Built-in &&.
function Fay$$and(x){
  return function(y){
    return _(x) && _(y);
  };
}

// Built-in ||.
function Fay$$or(x){
  return function(y){
    return _(x) || _(y);
  };
}

/*******************************************************************************
* Mutable references.
*/

// Make a new mutable reference.
function Fay$$Ref(x){
  this.value = x;
}

// Write to the ref.
function Fay$$writeRef(ref,x){
  ref.value = x;
}

// Get the value from the ref.
function Fay$$readRef(ref,x){
  return ref.value;
}

/*******************************************************************************
* Dates.
*/
function Fay$$date(str){
  return window.Date.parse(str);
}

/*******************************************************************************
* Application code.
*/


var sameDirAlert = new $(function(){return new Fay$$Monad(Fay$$unserialize("",window.alert('In the same directory the module works')));});var main = new $(function(){return _(_(Fay$$then)(sameDirAlert))(_(asdf)(Fay$$list("Hello, world!")));});var DateType = new $(function(){return [new Fay$$Constructor("DateType")];});var FunctionType = new $(function(){return [new Fay$$Constructor("FunctionType")];});var JsType = new $(function(){return [new Fay$$Constructor("JsType")];});var StringType = new $(function(){return [new Fay$$Constructor("StringType")];});var DoubleType = new $(function(){return [new Fay$$Constructor("DoubleType")];});var ListType = new $(function(){return [new Fay$$Constructor("ListType")];});var BoolType = new $(function(){return [new Fay$$Constructor("BoolType")];});var UnknownType = new $(function(){return [new Fay$$Constructor("UnknownType")];});var Just = function(slot1){return new $(function(){return [new Fay$$Constructor("Just"),slot1];});};var Nothing = new $(function(){return [new Fay$$Constructor("Nothing")];});var show = function($_a){return new $(function(){return Fay$$unserialize("string",Fay$$encodeShow(_($_a)));});};var fromInteger = function($_a){return new $(function(){var x = $_a;return x;});};var fromRational = function($_a){return new $(function(){var x = $_a;return x;});};var snd = function($_a){return new $(function(){var x = Fay$$index(1)(_($_a));return x;throw ["unhandled case in Ident \"snd\"",[$_a]];});};var fst = function($_a){return new $(function(){var x = Fay$$index(0)(_($_a));return x;throw ["unhandled case in Ident \"fst\"",[$_a]];});};var find = function($_a){return function($_b){return new $(function(){var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var x = $_$_b.car;var xs = $_$_b.cdr;var p = $_a;return _(_(p)(x)) ? _(Just)(x) : _(_(find)(p))(xs);}if (_($_b) === null) {var p = $_a;return Nothing;}throw ["unhandled case in Ident \"find\"",[$_a,$_b]];});};};var any = function($_a){return function($_b){return new $(function(){var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var x = $_$_b.car;var xs = $_$_b.cdr;var p = $_a;return _(_(p)(x)) ? true : _(_(any)(p))(xs);}if (_($_b) === null) {var p = $_a;return false;}throw ["unhandled case in Ident \"any\"",[$_a,$_b]];});};};var filter = function($_a){return function($_b){return new $(function(){var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var x = $_$_b.car;var xs = $_$_b.cdr;var p = $_a;return _(_(p)(x)) ? _(_(Fay$$cons)(x))(_(_(filter)(p))(xs)) : _(_(filter)(p))(xs);}if (_($_b) === null) {return null;}throw ["unhandled case in Ident \"filter\"",[$_a,$_b]];});};};var not = function($_a){return new $(function(){var p = $_a;return _(p) ? false : true;});};var _$null = function($_a){return new $(function(){if (_($_a) === null) {return true;}return false;});};var map = function($_a){return function($_b){return new $(function(){if (_($_b) === null) {return null;}var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var x = $_$_b.car;var xs = $_$_b.cdr;var f = $_a;return _(_(Fay$$cons)(_(f)(x)))(_(_(map)(f))(xs));}throw ["unhandled case in Ident \"map\"",[$_a,$_b]];});};};var nub = function($_a){return new $(function(){var ls = $_a;return _(_(nub$39$)(ls))(null);});};var nub$39$ = function($_a){return function($_b){return new $(function(){if (_($_a) === null) {return null;}var ls = $_b;var $_$_a = _($_a);if ($_$_a instanceof Fay$$Cons) {var x = $_$_a.car;var xs = $_$_a.cdr;return _(_(_(elem)(x))(ls)) ? _(_(nub$39$)(xs))(ls) : _(_(Fay$$cons)(x))(_(_(nub$39$)(xs))(_(_(Fay$$cons)(x))(ls)));}throw ["unhandled case in Ident \"nub'\"",[$_a,$_b]];});};};var elem = function($_a){return function($_b){return new $(function(){var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var y = $_$_b.car;var ys = $_$_b.cdr;var x = $_a;return _(_(_(Fay$$eq)(x))(y)) || _(_(_(elem)(x))(ys));}if (_($_b) === null) {return false;}throw ["unhandled case in Ident \"elem\"",[$_a,$_b]];});};};var GT = new $(function(){return [new Fay$$Constructor("GT")];});var LT = new $(function(){return [new Fay$$Constructor("LT")];});var EQ = new $(function(){return [new Fay$$Constructor("EQ")];});var sort = new $(function(){return _(sortBy)(compare);});var compare = function($_a){return function($_b){return new $(function(){var y = $_b;var x = $_a;return _(_(x) > _(y)) ? GT : _(_(x) < _(y)) ? LT : EQ;});};};var sortBy = function($_a){return new $(function(){var cmp = $_a;return _(_(foldr)(_(insertBy)(cmp)))(null);});};var insertBy = function($_a){return function($_b){return function($_c){return new $(function(){if (_($_c) === null) {var x = $_b;return Fay$$list([x]);}var ys = $_c;var x = $_b;var cmp = $_a;return (function($_ys){var $_$_ys = _($_ys);if ($_$_ys instanceof Fay$$Cons) {var y = $_$_ys.car;var ys$39$ = $_$_ys.cdr;return (function($tmp){if ((_($tmp))[0].name === "GT") {return _(_(Fay$$cons)(y))(_(_(_(insertBy)(cmp))(x))(ys$39$));}return _(_(Fay$$cons)(x))(ys);})(_(_(cmp)(x))(y));}return (function(){ throw (["unhandled case",$_ys]); })();})(ys);});};};};var when = function($_a){return function($_b){return new $(function(){var m = $_b;var p = $_a;return _(p) ? _(_(Fay$$then)(m))(_(Fay$$return)(Fay$$unit)) : _(Fay$$return)(Fay$$unit);});};};var enumFrom = function($_a){return new $(function(){var i = $_a;return _(_(Fay$$cons)(i))(_(enumFrom)(_(i) + 1));});};var enumFromTo = function($_a){return function($_b){return new $(function(){var n = $_b;var i = $_a;return _(_(_(Fay$$eq)(i))(n)) ? Fay$$list([i]) : _(_(Fay$$cons)(i))(_(_(enumFromTo)(_(i) + 1))(n));});};};var zipWith = function($_a){return function($_b){return function($_c){return new $(function(){var $_$_c = _($_c);if ($_$_c instanceof Fay$$Cons) {var b = $_$_c.car;var bs = $_$_c.cdr;var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var a = $_$_b.car;var as = $_$_b.cdr;var f = $_a;return _(_(Fay$$cons)(_(_(f)(a))(b)))(_(_(_(zipWith)(f))(as))(bs));}}return null;});};};};var zip = function($_a){return function($_b){return new $(function(){var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var b = $_$_b.car;var bs = $_$_b.cdr;var $_$_a = _($_a);if ($_$_a instanceof Fay$$Cons) {var a = $_$_a.car;var as = $_$_a.cdr;return _(_(Fay$$cons)(Fay$$list([a,b])))(_(_(zip)(as))(bs));}}return null;});};};var flip = function($_a){return function($_b){return function($_c){return new $(function(){var y = $_c;var x = $_b;var f = $_a;return _(_(f)(y))(x);});};};};var maybe = function($_a){return function($_b){return function($_c){return new $(function(){if ((_($_c))[0].name === "Nothing") {var f = $_b;var m = $_a;return m;}if ((_($_c))[0].name === "Just") {var x = (_($_c))[1];var f = $_b;var m = $_a;return _(f)(x);}throw ["unhandled case in Ident \"maybe\"",[$_a,$_b,$_c]];});};};};var $46$ = function($_a){return function($_b){return function($_c){return new $(function(){var x = $_c;var g = $_b;var f = $_a;return _(f)(_(g)(x));});};};};var $43$$43$ = function($_a){return function($_b){return new $(function(){var y = $_b;var x = $_a;return _(_(conc)(x))(y);});};};var $36$ = function($_a){return function($_b){return new $(function(){var x = $_b;var f = $_a;return _(f)(x);});};};var conc = function($_a){return function($_b){return new $(function(){var ys = $_b;var $_$_a = _($_a);if ($_$_a instanceof Fay$$Cons) {var x = $_$_a.car;var xs = $_$_a.cdr;return _(_(Fay$$cons)(x))(_(_(conc)(xs))(ys));}var ys = $_b;if (_($_a) === null) {return ys;}throw ["unhandled case in Ident \"conc\"",[$_a,$_b]];});};};var concat = new $(function(){return _(_(foldr)(conc))(null);});var foldr = function($_a){return function($_b){return function($_c){return new $(function(){if (_($_c) === null) {var z = $_b;var f = $_a;return z;}var $_$_c = _($_c);if ($_$_c instanceof Fay$$Cons) {var x = $_$_c.car;var xs = $_$_c.cdr;var z = $_b;var f = $_a;return _(_(f)(x))(_(_(_(foldr)(f))(z))(xs));}throw ["unhandled case in Ident \"foldr\"",[$_a,$_b,$_c]];});};};};var foldl = function($_a){return function($_b){return function($_c){return new $(function(){if (_($_c) === null) {var z = $_b;var f = $_a;return z;}var $_$_c = _($_c);if ($_$_c instanceof Fay$$Cons) {var x = $_$_c.car;var xs = $_$_c.cdr;var z = $_b;var f = $_a;return _(_(_(foldl)(f))(_(_(f)(z))(x)))(xs);}throw ["unhandled case in Ident \"foldl\"",[$_a,$_b,$_c]];});};};};var lookup = function($_a){return function($_b){return new $(function(){if (_($_b) === null) {var _key = $_a;return Nothing;}var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var x = Fay$$index(0)(_($_$_b.car));var y = Fay$$index(1)(_($_$_b.car));var xys = $_$_b.cdr;var key = $_a;return _(_(_(Fay$$eq)(key))(x)) ? _(Just)(y) : _(_(lookup)(key))(xys);}throw ["unhandled case in Ident \"lookup\"",[$_a,$_b]];});};};var intersperse = function($_a){return function($_b){return new $(function(){if (_($_b) === null) {return null;}var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var x = $_$_b.car;var xs = $_$_b.cdr;var sep = $_a;return _(_(Fay$$cons)(x))(_(_(prependToAll)(sep))(xs));}throw ["unhandled case in Ident \"intersperse\"",[$_a,$_b]];});};};var prependToAll = function($_a){return function($_b){return new $(function(){if (_($_b) === null) {return null;}var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var x = $_$_b.car;var xs = $_$_b.cdr;var sep = $_a;return _(_(Fay$$cons)(sep))(_(_(Fay$$cons)(x))(_(_(prependToAll)(sep))(xs)));}throw ["unhandled case in Ident \"prependToAll\"",[$_a,$_b]];});};};var intercalate = function($_a){return function($_b){return new $(function(){var xss = $_b;var xs = $_a;return _(concat)(_(_(intersperse)(xs))(xss));});};};var forM_ = function($_a){return function($_b){return new $(function(){var m = $_b;var $_$_a = _($_a);if ($_$_a instanceof Fay$$Cons) {var x = $_$_a.car;var xs = $_$_a.cdr;return _(_(Fay$$then)(_(m)(x)))(_(_(forM_)(xs))(m));}if (_($_a) === null) {return _(Fay$$return)(Fay$$unit);}throw ["unhandled case in Ident \"forM_\"",[$_a,$_b]];});};};var mapM_ = function($_a){return function($_b){return new $(function(){var $_$_b = _($_b);if ($_$_b instanceof Fay$$Cons) {var x = $_$_b.car;var xs = $_$_b.cdr;var m = $_a;return _(_(Fay$$then)(_(m)(x)))(_(_(mapM_)(m))(xs));}if (_($_b) === null) {return _(Fay$$return)(Fay$$unit);}throw ["unhandled case in Ident \"mapM_\"",[$_a,$_b]];});};};
// Exports
this.sameDirAlert = sameDirAlert;
this.main = main;

// Built-ins
this.$force      = _;
this.$           = $;
this.$list       = Fay$$list;
this.$encodeShow = Fay$$encodeShow;
this.$eval       = Fay$$eval;

};
;
var main = new SameDir();
main.$force(main.main);

