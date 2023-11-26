<?php

namespace App\Http\Controllers;

use App\Models\ActiveToken;
use App\Models\BlackListToken;
use App\Models\User;
use App\Services\FirebaseJwtAuth;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Symfony\Component\HttpFoundation\Response;

class AuthController extends Controller
{
    protected $firebaseJwtAuth;

    public function __construct(FirebaseJwtAuth $firebaseJwtAuth)
    {
        $this->firebaseJwtAuth = $firebaseJwtAuth;
    }

    public function login(Request $request)
    {
        try {
            // Valide os campos de entrada
            $request->validate([
                'email' => 'required|email',
                'password' => 'required',
            ]);

            // Encontre o usuário com as credenciais fornecidas
            $user = User::with('photo')->where('email', $request->email)->first();
            if (!$user || !Hash::check($request->password, $user->password)) {
                return response()->json(['message' => 'Credenciais inválidas'], 401);
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

            if (empty($user->apelido)) {
                $user->apelido = explode(' ', $user->name)[0];
            }
            return new JsonResponse(compact('token', 'user'), Response::HTTP_OK);
        } catch (Exception $e) {
            return new JsonResponse(['message' => $e->getMessage()], Response::HTTP_BAD_REQUEST);
        }
    }

    public function me(Request $request)
    {
        $user = $request->user;
        if (empty($user->apelido)) {
            $user->apelido = explode(' ', $user->name)[0];
        }
        return new JsonResponse($user, Response::HTTP_OK);
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

        return new JsonResponse(['message' => 'Logout efetuado com sucesso'], Response::HTTP_OK);
    }
}
