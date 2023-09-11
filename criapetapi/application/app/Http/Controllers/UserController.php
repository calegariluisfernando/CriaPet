<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Services\ErrorMessageService;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rules\File;
use Illuminate\Validation\ValidationException;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $users = User::all()->map(function (User $user){
            if (empty($user->apelido)) {
                $user->apelido = explode(' ', $user->name)[0];
            }
            return $user;
        });

        return new JsonResponse($users);
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
                'apelido' =>'string|min:3|max:45',
                'password' =>'required|string|min:8',
                'photo' => [
                    File::types(['jpg', 'jpeg', 'png', 'gif'])->max(12 * 1024),
                ],
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
            return new JsonResponse(['error' => ErrorMessageService::handleException($e)], JsonResponse::HTTP_INTERNAL_SERVER_ERROR);
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
    public function show(User $user)
    {
        if (empty($user->apelido)) {
            $user->apelido = explode(' ', $user->name)[0];
        }
        return new JsonResponse($user);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, User $user)
    {
        try {
            $request->validate([
                'name' =>'string|min:3|max:250',
                'apelido' =>'string|min:3|max:45',
                'email' =>'email|max:250|unique:users',
                'photo' => [
                    File::types(['jpg', 'jpeg', 'png', 'gif'])->max(12 * 1024),
                ],
            ]);

            if ($request->has('name')) {
                $user->name = $request->input('name');
            }

            if ($request->has('apelido')) {
                $user->apelido = $request->input('apelido');
            }

            if ($request->has('email')) {
                $user->email = $request->input('email');
            }

            if ($request->hasFile('photo')) {
                $file = $request->file('photo');
                $originalFileName = $file->getClientOriginalName();

                $extension      = pathinfo($originalFileName, PATHINFO_EXTENSION);
                $basename       = bin2hex(random_bytes(8));
                $newFilename    = date('U'). sprintf('%s.%0.8s', $basename, $extension);
                $directory      = $this->getPathPhotoUpload('user_photo');

                $file->storeAs($directory, $newFilename, 'private');

                $user->photo = $newFilename;
            }

            $user->save();

            return new JsonResponse($user);
        } catch (ValidationException $e) {
            return new JsonResponse(['error' => $e->getMessage()], JsonResponse::HTTP_BAD_REQUEST);
        } catch (Exception $e) {
            return new JsonResponse(['error' => ErrorMessageService::handleException($e)], JsonResponse::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        $user->delete();
        return new JsonResponse(null, JsonResponse::HTTP_NO_CONTENT);
    }
}
