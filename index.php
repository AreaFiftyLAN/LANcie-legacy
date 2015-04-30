<?php
header('Content-type: application/json');
header('Access-Control-Allow-Origin: *');

// We're still developing
error_reporting(E_ALL);
ini_set('display_errors', true);

require "../vendor/autoload.php";
require "Service/BaseService.php";

/* Setup db connection */
use Database\MySQL as Database;

/* Process request
** Request form is:
** 	areafiftylan.nl/index.php?TYPE/REQUEST
** 	(eg. GET areafiftylan.nl/api/user/12)
*/

function getControllerFromType($type) {
    $type = ucfirst($type);

    $host = "joost.chnet";
    $user = "cie_lancie";
    $pass = "j8mjyPBC6NB7R5rM";
    $db = new Database($user, $pass, "cie_lancie", $host);

    $class = '\\Mapper\\'.$type.'Mapper';
    $mapper = new $class($db);

    $modelClass = '\\Model\\'.$type.'Model'; // Contains all information

    $class = '\\Service\\'.$type.'Service'; // Performs operations data from Model
    $service = new $class($mapper, $modelClass);

    $class = '\\Controller\\'.$type.'Controller';
    $controller = new $class($service);

    return $controller;
}

$app = new \Slim\Slim();

$app -> get('/test/:userid', function($userid) {
    $controller = getControllerFromType("order");

    $controller -> updateById($userid);
});

$app->group('/user', function () use ($app) {

    $controller = getControllerFromType("user");

    $app -> get('/get/:userid', function ($userid) use ($controller) {
        api_call("user");
        try {
            echo $controller -> get($userid) -> toJSON();
        } catch (Exception $e) {
            echo $e;
        }
    });

    $app -> get('/hash/:hash', function($hash) use ($controller) {
        api_call("user");
        try {
            echo $controller -> getUserIdByHash($hash);
        } catch(Exception $e) {
            echo $e;
        }
    });

    $app->post('/create/:userid', function () use ($app, $controller) {
        api_call("user");
        try {
            $controller -> create($app -> request() -> getBody());
            echo json_encode(array(
                "status" => 201,
                "message" => "OK"
            ));
        } catch (Exception $e) {
            echo $e;
        }
    });

    $app->get('/check(/)(/:username)', function ($username = "default") use ($controller) {
        api_call("user");
        try {
            if($controller -> getUsernameExists($username)) {
                echo 'true';
            } else {
                echo 'false';
            }
        } catch (Exception $e) {
            echo $e;
        }
    });

    $app -> get('/checkemail(/)(/:email)', function ($email = "default") use ($controller) {
        api_call("user");
        try {
            if($controller -> getEmailExists($email)) {
                echo 'true';
            } else {
                echo 'false';
            }
        } catch (Exception $e) {
            echo $e;
        }
    });

    $app -> get('/verify/:email/:hash', function($email, $hash) use ($controller) {
        api_call("user");
        try {
            $controller -> verify($email, $hash);
        } catch (Exception $e) {
            echo $e;
        }
    });

    $app -> get('/lan/cie/bravo/skillas/noscope/counter', function() use ($controller) {
        api_call("user");
        try {
            echo 'Preregistrations: ' . $controller -> getPreregisterCount() . ' B\'vo';
        } catch (Exception $e) {
            echo $e;
        }
    });
});

$app->group('/order', function () use ($app) {

    $controller = getControllerFromType("order");

    $app->get('/get/:orderid', function($orderid) use ($controller) {
        api_call("order");
        try {
            echo $orderid;
        } catch(Exception $e) {
            echo $e;
        }
    });

    $app -> get('/paid/:userid', function($userid) use ($controller) {
        api_call("order");
        try {
            echo json_encode($controller -> userPaid($userid));
        } catch(Exception $e) {
            echo $e;
        }
    });
});

$app->group('/profile', function() use ($app) {

    $controller = getControllerFromType("profile");

    $app -> get('/get/:userid', function($userid) use ($controller) {
        api_call("profile");
        try {
            echo $controller -> get($userid) -> toJSON();
        } catch(Exception $e) {
            echo $e;
        }
    });

    $app -> post('/create/:userid', function($userid) use ($app, $controller) {
        api_call("profile");
        try {
            $controller -> create($userid, $app -> request() -> getBody());
            echo json_encode(array(
                "status" => 201,
                "message" => "OK"
            ));
        } catch (Exception $e) {
            echo $e;
        }
    });
});

$app->group('/mail', function() use ($app) {
    $app -> post('/send/:hash', function($hash) {
        api_call("mail");
        if($hash == '711b5be7894423bda24a282cf2ec361c') {
            $name = test_input($_POST['name']);
            $email = test_input($_POST['email']);
            $message = "naam: $name \n\nemail: $email\n\n" . test_input($_POST['message']);
            $subject = "[LANcie info]" . test_input($_POST['subject']);
            $to = "lancie@ch.tudelft.nl";
            mail($to, $subject, $message);
            echo json_encode(array(
                "status" => 201,
                "message" => "Mail send!"
            ));
        }
    });
});

$app -> group('/account', function() use ($app) {
    $app -> post('/create(/)', function () use ($app) {
        api_call("account");
        try {
            $AccountController = new \Controller\AccountController(getControllerFromType("user"), getControllerFromType("profile"), getControllerFromType("order"));
            echo json_encode($AccountController -> create($app -> request() -> getBody()));
        } catch (Exception $e) {
            echo $e;
        }
    });

    $app -> get('/order/:userid', function($userid) {
        api_call("account");
        try {
            $AccountController = new \Controller\AccountController(getControllerFromType("user"), getControllerFromType("profile"), getControllerFromType("order"));
            echo json_encode($AccountController -> createOrder($userid));
        } catch(Exception $e) {
            echo $e;
        }
    });
});

function test_input($data) {
    return htmlspecialchars(stripslashes(trim($data)));
}

function api_call($type) {
    $host = "joost.chnet";
    $user = "cie_lancie";
    $pass = "j8mjyPBC6NB7R5rM";
    $db = new Database($user, $pass, "cie_lancie", $host);

    $query = "INSERT INTO lancie_call (type) VALUES (?)";

    $db -> query($query, false, [$type]);
}

$app->run();
