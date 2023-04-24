<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Services\FirebaseJwtAuth;
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

        return response()->json(compact('token'));
    }

    public function me(Request $request)
    {
        return response()->json($request->user);
    }

    public function logout(Request $request)
    {
        Auth::logout();

        return response()->json(['message' => 'Logout efetuado com sucesso']);
    }
}
