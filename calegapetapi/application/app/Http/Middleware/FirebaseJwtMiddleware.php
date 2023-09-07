<?php

namespace App\Http\Middleware;

use App\Models\BlackListToken;
use App\Models\User;
use App\Services\FirebaseJwtAuth;
use Closure;

class FirebaseJwtMiddleware
{
    protected $firebaseJwtAuth;

    public function __construct(FirebaseJwtAuth $firebaseJwtAuth)
    {
        $this->firebaseJwtAuth = $firebaseJwtAuth;
    }

    public function handle($request, Closure $next)
    {
        $token = $request->header('Authorization');
        if (!$token) {
            return response()->json(['error' => 'Token não fornecido'], 401);
        }
        $token = explode(' ', $token)[1];
        $decoded = $this->firebaseJwtAuth->verifyToken($token);
        if (!$decoded) {
            return response()->json(['error' => 'Token inválido'], 401);
        }

        $tokenInBlackList = BlackListToken::where('token', $token)->first();
        if (!empty($tokenInBlackList)) {
            return response()->json(['error' => 'Token está na BlackList'], 401);
        }

        // Adicione o utilizador autenticado ao objeto $request para uso posterior
        $request->user = User::find($decoded->sub);

        return $next($request);
    }
}
