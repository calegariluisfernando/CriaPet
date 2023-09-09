<?php

namespace App\Http\Controllers;

use App\Models\User;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return new JsonResponse(User::all());
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return new JsonResponse(['error' => 'Page not found'], JsonResponse::HTTP_NOT_FOUND);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try {
            $request->validate([
                'name' =>'required|string|min:3|max:250',
                'email' =>'required|email|max:250|unique:users',
                'password' =>'required|string|min:8',
            ]);

            $dados = [
                'name' => $request->name,
                'email' => $request->email,
                'password' => $request->password,
            ];

            if ($request->hasFile('photo')) {
                $file = $request->file('photo');
                $originalFileName = $file->getClientOriginalName();

                $extension      = pathinfo($originalFileName, PATHINFO_EXTENSION);
                $basename       = bin2hex(random_bytes(8));
                $newFilename    = date('U'). sprintf('%s.%0.8s', $basename, $extension);
                $directory      = $this->getPathPhotoUpload('user_photo');

                $file->storeAs($directory, $newFilename, 'private');

                $dados['photo'] = $newFilename;
            }

            $user = User::create($dados);

            return new JsonResponse($user, JsonResponse::HTTP_CREATED);
        } catch (ValidationException $e) {
            return new JsonResponse(['error' => $e->getMessage()], JsonResponse::HTTP_BAD_REQUEST);
        } catch (Exception $e) {
            return new JsonResponse(['error' => 'Erro interno'], JsonResponse::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    private function getPathPhotoUpload(string $p) : string {
        $path = DIRECTORY_SEPARATOR . $p;
        $path .= DIRECTORY_SEPARATOR . date('Y');
        $path .= DIRECTORY_SEPARATOR . date('m');
        $path .= DIRECTORY_SEPARATOR . date('d');

        return $path;
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
