<?php

namespace App\Http\Controllers;

use App\Models\ActiveToken;
use App\Models\BlackListToken;
use App\Models\User;
use App\Services\FirebaseJwtAuth;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    protected $firebaseJwtAuth;

    public function __construct(FirebaseJwtAuth $firebaseJwtAuth)
    {
        $this->firebaseJwtAuth = $firebaseJwtAuth;
    }

    public function login(Request $request)
    {
        // Valide os campos de entrada
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        // Encontre o usuário com as credenciais fornecidas
        $user = User::where('email', $request->email)->first();
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['error' => 'Credenciais inválidas'], 401);
        }

        // Crie um token JWT e retorne-o para o cliente
        $token = $this->firebaseJwtAuth->createToken($user);

        // Remover da tabela de Tokens Ativos o Token do Usuario, medida de
        // segurança caso o usuário realize login mais de uma vez.
        $tokensDoUsuario = ActiveToken::where('user_id', $user->id)->first();
        if (!empty($tokensDoUsuario)) {
            BlackListToken::create(['token' => $tokensDoUsuario->token]);
            $tokensDoUsuario->delete();
        }

        // Adicionar Token Gereado na tabela de Tokens ativos do Usuário.
        ActiveToken::create(['user_id' => $user->id, 'token' => $token]);

        return new JsonResponse(compact('token', 'user'), JsonResponse::HTTP_OK);
    }

    public function me(Request $request)
    {
        return new JsonResponse($request->user, JsonResponse::HTTP_OK);
    }

    public function logout(Request $request)
    {
        $token = explode(' ', $request->header('Authorization'))[1];
        $user = $request->user;

        $tokensDoUsuario = ActiveToken::where('user_id', $user->id)->first();
        if (!empty($tokensDoUsuario)) {
            $tokensDoUsuario->delete();
        }

        BlackListToken::create(['token' => $token]);

        return new JsonResponse(['message' => 'Logout efetuado com sucesso'], JsonResponse::HTTP_OK);
    }
}
