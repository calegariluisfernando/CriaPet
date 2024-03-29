<?php

use App\Http\Controllers\AnimalController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\EspecieController;
use App\Http\Controllers\RacaController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\FirebaseJwtMiddleware;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::prefix('auth')->group(function () {
    Route::post('login', [AuthController::class, 'login']);
    Route::middleware([FirebaseJwtMiddleware::class])->group(function () {
        Route::get('me', [AuthController::class, 'me']);
        Route::post('logout', [AuthController::class, 'logout']);
        /*Route::post('refresh', [AuthController::class, 'refresh']);*/
    });
});


Route::prefix('users')->group(function () {
    Route::post('', [UserController::class, 'store']);
    Route::middleware([FirebaseJwtMiddleware::class])->group(function () {
        Route::get('', [UserController::class, 'index']);
        Route::get('{user}', [UserController::class, 'show']);
        Route::put('{user}', [UserController::class, 'update']);
        Route::delete('{user}', [UserController::class, 'destroy']);
        Route::get('/photo/{user}', [UserController::class, 'photo']);
    });
});

Route::prefix('animal')->middleware([FirebaseJwtMiddleware::class])->group(function () {
    Route::get('', [AnimalController::class, 'index']);
});

Route::prefix('especie')->middleware([FirebaseJwtMiddleware::class])->group(function () {
    Route::get('', [EspecieController::class, 'index']);
    Route::post('', [EspecieController::class, 'store']);
});

Route::prefix('raca')->middleware([FirebaseJwtMiddleware::class])->group(function () {
    Route::get('', [RacaController::class, 'index']);
    Route::post('', [RacaController::class, 'store']);
});
